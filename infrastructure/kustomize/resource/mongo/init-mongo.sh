#!/bin/bash

set -em

# make sure all the required variables are set
for var in MONGO_ADMIN_USERNAME MONGO_ADMIN_PASSWORD STATEFUL_SET_NAME POD_NAME MONGO_REPLICA_COUNT; do
    if [[ -z "${!var}" ]]; then
        echo "Missing required variable: $var"
        exit 1
    fi
done

# matches what's in mongo.yaml
KEYFILE_LOCATION=/mongo-certificates/keyfile

START_TIME="$(date +"%s")"

REPLICA_SET_NAME=rs0

# The hostnames that are used here need to match the hostnames that a client would use to connect, otherwise the client
# connection will not work
MY_HOSTNAME="$(hostname).mongo.mongo"
echo "127.0.0.1 ${MY_HOSTNAME}" >> /etc/hosts

set_pod_ready() {
    log "Setting pod to READY status"
    # This file is what the k8s readinessProbe looks for. Creating this will tell k8s that the container is ready
    touch /tmp/mongo-ready
}

pod_is_ready() {
    cat /tmp/mongo-ready >> /dev/null
}

log() {
    local msg="$1"
    local timestamp
    timestamp=$(date)
    echo "[$0] [$timestamp] $msg" 1>&2
}


shutdown_mongo() {
    log "Shutting down mongo"
    if (! mongo admin --eval "db.shutdownServer({force: true})"); then
      log "db.shutdownServer() failed, sending the terminate signal"
      kill %1
    fi
}

log "Starting mongod process with arguments: '$@'"
# Start mongod in the background at first so that we can continue to execute some other commands
# to initialize the replica set. We'll move this mongod process back to the foreground after we're done
# as long as everything is successful
mongod --bind_ip 0.0.0.0 --replSet "$REPLICA_SET_NAME" --auth --clusterAuthMode keyFile --keyFile $KEYFILE_LOCATION --setParameter authenticationMechanisms=SCRAM-SHA-1 $@ &
MONGO_PID="$!"

# stop mongodb when the shell exits. This might happen anyway, but the particulars of bash job management in weird scenarios is a mystery to me
trap shutdown_mongo EXIT
# just to give mongod time to get ready
sleep 10

eval_js() {
    local host=$1
    # write the js to a temp file and then pipe that to the mongo shell. This saves us when the js
    # includes bash special chars. Such js can be passed to this function safely just by using single quotes
    # but evaluating it in bash is a bit more tricky
    echo "$2" > tmp-script.js

    local credentials="-u $MONGO_ADMIN_USERNAME -p $MONGO_ADMIN_PASSWORD"
    mongo --quiet --host $host $credentials admin < tmp-script.js || echo "Evaluation of JS failed"
}

retry_local_until() {
    local command="${1}"
    local expected="${2}"

    # Leader election could take a while, and we don't really have a good way to recover if it fails
    local timeout_seconds=300
    local start_time="$(date +"%s")"
    local elapsed=0

    # rely on the localhost exception to allow this to work
    local result=$(mongo --quiet admin --eval "${command}")
    until [[ "$result" == "${expected}" ]]; do
        log "Waiting for '${command}' to return '${expected}', got: '${result}'"
        sleep 1

        if (! ps "${MONGO_PID}" &>/dev/null); then
            log "mongod shutdown unexpectedly"
            exit 1
        fi

        elapsed=$(( $(date +"%s") - $start_time ))

        if [[ "${elapsed}" -ge "${timeout_seconds}" ]]; then
            log "Timed out after ${timeout_seconds}s attempting to bootstrap mongod"
            exit 1
        fi

        log "Retrying ${command} on local mongo instance"
    done
}


wait_util_hostname_resolves() {
    local host=$1

    local start_time="$(date +"%s")"
    local elapsed=0
    local timeout_seconds=120

    while [[ "${elapsed}" -lt "${timeout_seconds}" ]]; do

        if mongo --quiet --host $host --eval true; then
            return 0
        else
            log "Host: ${host} was not reachable yet. Will retry"
            sleep 10
            elapsed=$(( $(date +"%s") - $start_time ))
        fi
    done

    # if we make it here then the host was not reachable before the timeout
    return 1
}

init_replica_set() {
    # This function should ONLY ever be called once in the whole lifetime of the mongo statefulset.
    # Everything in this function needs to execute successfully before the second mongo instance starts up,
    # especially the part about waiting until this instance becomes primary
    log "Initializing new ReplicaSet"
    mongo admin --eval "rs.initiate({'_id': '${REPLICA_SET_NAME}', 'members': [{'_id': 0, 'host': '${MY_HOSTNAME}'}] } )"
    log "Waiting to become primary"
    sleep 3
    retry_local_until 'db.isMaster().ismaster' 'true'
    log "${MY_HOSTNAME} is now primary"

    log "creating admin user"
    mongo admin --eval "db.createUser( { user: '${MONGO_ADMIN_USERNAME}', pwd: '${MONGO_ADMIN_PASSWORD}', roles: [ { role: 'root', db: 'admin' } ] } )"
}

should_initialize_replica_set() {
    # Only initialize the replicaset on the very first pod, since the StatefulSet controller always brings them up in order
    if [[ "${POD_NAME}" == "${STATEFUL_SET_NAME}-0" ]]; then
        local js='rs.status().errmsg'
        log "Evaluating js locally: ${js}"
        # don't use eval_js because that only works once auth is enabled. Instead we're checking to see if this is the very first initialization
        local result=$(mongo --quiet --eval $js || echo "Evaluation of JS failed")
        if [[ "$result" == "no replset config has been received" ]]; then
            log "Will attempt to initialize the replicaset since since this is the first Pod in the StatefulSet and mongo reports that ${result}"
            echo "true"
        else
            log "Will not attempt to initialize the replicaset since it may already be initialized. JS result: '${result}'"
            echo "false"
        fi
    else
        log "Will not attempt to initialize the replicaset since this is not the first pod in the StatefulSet"
        echo "false"
    fi
}

is_host_in_replicaset() {
    local remote_host="$1"
    local host_to_check="$2"
    local js="rs.status().members.find(function(mem) { return mem.name.startsWith(\"${host_to_check}\"); }) != null;"
    log "checking with remote_host: '${remote_host}' to see if '${js}' evaluates to true"
    local result="$(eval_js ${remote_host} "${js}")"
    log "Host: '${host_to_check}' is in replicaSet: '${result}'"
    echo $result
}

determine_primary_host() {
    # We'll loop over all the mongo hosts and check each one to see if it knows which instance is primary
    PRIMARY_HOST=""
    for i in $(seq 0 $(($MONGO_REPLICA_COUNT - 1)) ); do
        local peer_host="${STATEFUL_SET_NAME}-${i}.mongo.mongo"
        log "Checking '${peer_host}' to see if it knows which instance is primary'"
        local peer_result="$(eval_js ${peer_host} 'db.isMaster().primary' )"
        if [[ "$peer_result" =~ ^${STATEFUL_SET_NAME}-[0-9].* ]]; then
            log "Determined that mongo primary is '${peer_result}'"
            PRIMARY_HOST=${peer_result}
            break
        else
            log "Unable to determine if host: ${peer_host} has initialized the replica set, result: ${peer_result}"
        fi
    done

    echo ${PRIMARY_HOST}
}

add_this_instance_to_replica_set() {
    log "adding ${MY_HOSTNAME} to replicaset using ${PRIMARY_HOST}"
    eval_js ${PRIMARY_HOST} "rs.add('${MY_HOSTNAME}')"
}

STATEFUL_SET_PREFIX="${STATEFUL_SET_NAME}-"
MY_ORDINAL="${POD_NAME#$STATEFUL_SET_PREFIX}"
log "this instance stateful set ordinal is: ${MY_ORDINAL}"
# the StatefulSet controller always starts pods in order, so any pods with an ordinal <= this instance need to have its
# hostname be resolvable before we can try to initalize the replicaset or add this instance to it
for i in $(seq 0 ${MY_ORDINAL} ); do
    peer_host="${STATEFUL_SET_NAME}-${i}.mongo.mongo";
    log "testing peer host: ${peer_host}"

    if [[ "$peer_host" == "$MY_HOSTNAME" ]] || wait_util_hostname_resolves "$peer_host"; then
        log "Hostname '${peer_host}' resolves successfully"
    else
        log "host: ${peer_host} did not resolve before timeout period"
    fi
done

SHOULD_INITIALIZE_REPLICASET="$(should_initialize_replica_set)"

if [[ "${SHOULD_INITIALIZE_REPLICASET}" == "true" ]]; then
    init_replica_set
    set_pod_ready
else
    log "Replicaset is already initialized. Will attempt to add this instance to the replicaset if necessary"
    PRIMARY_HOST="$(determine_primary_host)"


    if [[ -n "${PRIMARY_HOST}" ]]; then
        log "Determined that host '${PRIMARY_HOST}' is primary, will add this instance to the replicaset if required"

        # Set the pod ready, then wait a bit before trying to add this instance to the replicaset. This is to help ensure
        # that this pod is reachable from the other pods after we add it to the replicaset
        set_pod_ready
        if [[ "$(is_host_in_replicaset ${PRIMARY_HOST} ${MY_HOSTNAME})" != "true" ]]; then
            sleep 10
            add_this_instance_to_replica_set
        else
            log "This host is already added to the replicaset"
        fi
    else
        log "Warning: replicaset has been initialized, but no primary node could be detected. This is possibly indicative of an initialization error, but it could also be caused by all of the pods in the replica set being unreachable at the same time."

        # We will want to consider this pod READY, even though things might not be quite right.
        # This is to account for the possibility that a majority of mongo pods have crashed at around the same time.
        # If that happened, then we must bring this pod up in a 'READY' state before a new leader can be elected.
        set_pod_ready
    fi

fi

if [[ pod_is_ready ]]; then
    log "Startup looks successful, moving mongod process into the foreground"
    # Bring the background mongo process back into the foreground
    fg %1
else
    # It's very unlikely that we'll end up in this branch, but it could happen if init_replica_set fails
    log "Pod is still not ready, exiting"
    exit 1
fi
