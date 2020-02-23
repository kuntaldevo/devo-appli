#!/usr/bin/env bash

set -e

INSTALL_NAME_LABEL="paxata.com/installation-name"

function usage() {
    cat << EOF
usage: $0 [-h][-l <app> | -L][-o <output-dir> | -z <output-file>] <namesapce> <name>

Dumps debug information for a Paxata installation running in Kubernetes. The installation is identified by the <namespace> and <name> arguments.
Requires that you are already logged in to a cluster.

Options:
    -h: Print this help information and exit
    -l <app>: Also get the logs for a particular app, where app is one of "paxserver" or "pipeline-proxy"
    -L: Get the logs for all applications in the installation. Equivalent to passing -l paxserver -l pipeline-proxy
    -o <output-dir>: write the output to files in the given directory instead of printing it to stdout. Cannot be used with -z
    -z <output-file>: Bundle all the output files into a zip file in the given location. Use this if you want to send the debug info to someone else. Cannot be used with -o

EOF
}

function bail() {
    echo "$1" 1>&2
    usage
    exit 1
}


declare -a LOG_APPS
OUTPUT_DIR=""
ZIP_OUTPUT_FILE=""
while getopts ":ho:z:l:L" opt; do
    case "$opt" in
        h)
            usage
            exit 0
            ;;
        l)
            LOG_APPS+=("$OPTARG")
            ;;
        L)
            LOG_APPS=("paxserver" "pipeline-proxy")
            ;;
        o)
            if [[ ! -z "$ZIP_OUTPUT_FILE" ]]; then
                bail "cannot set both -o and -z options"
            fi
            OUTPUT_DIR="$OPTARG"
            mkdir -p "$OUTPUT_DIR"
            ;;
        z)
            if [[ ! -z "$OUTPUT_DIR" ]]; then
                bail "cannot set both -z and -o options"
            fi
            ZIP_OUTPUT_FILE="$OPTARG"
            if [[ -f "$ZIP_OUTPUT_FILE" ]]; then
                bail "Cannot write to '${ZIP_OUTPUT_FILE}' because it already exists"
            fi
            # create a temp dir as described by: https://unix.stackexchange.com/a/84980
            OUTPUT_DIR=`mktemp -d 2>/dev/null || mktemp -d -t 'installation-debug'`
            ;;
        \?)
            bail "Invalid option: $OPTARG"
            ;;
        : )
            bail "Invalid option: $OPTARG requires an argument"
            ;;
    esac
done
# shift out all the args that getops has processed before we start processing positional args
shift $(($OPTIND - 1))

function log() {
    echo "$@" 1>&2
    if [[ ! -z "$OUTPUT_DIR" ]]; then
        # if the output dir exists, then we'll also write the log message to a log file in there, so it can be included
        # in any zip file that gets sent
        echo "[ $(date +%FT%T%Z) ] $@" >> "${OUTPUT_DIR}/script.log"
    fi
}

function cleanup_tempdir() {
    if [[ ! -z "$ZIP_OUTPUT_FILE" ]]; then
        log "Cleaning up temp directory: '${OUTPUT_DIR}'"
        rm -rf "$OUTPUT_DIR"
    fi
}
trap cleanup_tempdir SIGINT SIGTERM

# now parse the positional arguments
NAMESPACE="$1"
NAME="$2"
log "using namespace: '${NAMESPACE}', name: '${NAME}'"

if [[ -z "$NAMESPACE" ]]; then
    bail "Missing required argument <namespace>"
fi
if [[ -z "$NAME" ]]; then
    bail "Missing required argument <name>"
fi
# shift out the positional arguments, so that we can ensure there are no more arguments remaining
shift 2

if [[ ! -z "$@" ]]; then
    REMAINING="$@"
    bail "Options must come before positional arguments. Bailing out, since '${REMAINING}' would get ignored, which is probably not what you want"
fi

# describing by label is better than by name, since we can reuse this function for services as well as pods or whatever else
function kube_describe_by_label() {
    local res_type="$1"
    log "executing: " kubectl -n "$NAMESPACE" describe "$res_type" -l "${INSTALL_NAME_LABEL}=${NAME}"
    kubectl -n "$NAMESPACE" describe "$res_type" -l "${INSTALL_NAME_LABEL}=${NAME}"
}

function kube_get_events() {
    log "executing: " kubectl -n "$NAMESPACE" -o yaml get events
    kubectl -n "$NAMESPACE" -o yaml get events
}

# directs output to either stdout or a file inside the OUTPUT_DIR if one is set
function do_get() {
    local filename="$1"
    shift 1
    local command="$@"
    log "Retrieving ${filename} using: ${command}"
    if [[ -z "$OUTPUT_DIR" ]]; then
        echo ""
        echo "${filename}:"
        eval "$@"
    else
        echo -e "#created by installation-debug-dump.sh on $(date +%FT%T%Z)\n\n" > "${OUTPUT_DIR}/${filename}"
        eval "$@" >> "${OUTPUT_DIR}/${filename}"
    fi
}

# grabs logs for the given app, directing them either to stdout or to the OUTPUT_DIR if one is set
function do_get_logs() {
    local app="$1"
    log "getting logs for app: $app"
    local container=""
    if [[ "$app" == "paxserver" ]]; then
        container="-c paxserver"
    fi

    do_get "${app}.log" kubectl -n "$NAMESPACE" logs "${NAME}-${app}" "$container"
}

# Now we can start actually getting the info from k8s
# if the installation doesn't exist, then we'll bail. If anything else is missing, then we'll keep chugging along, since that's the kind of thing we're hoping to diagnose
do_get 'paxinstallation.yaml' kubectl -n "$NAMESPACE" get pax "$NAME" -o yaml || bail "No such installation exists in namespace: '${NAMESPACE}', name: '${NAME}'"
do_get 'pods.txt' kube_describe_by_label pods || log "no pods exist for installation $NAME"
do_get 'services.txt' kube_describe_by_label services || log "no services exist for installation $NAME"
do_get 'configmaps.txt' kube_describe_by_label configmaps || log "no configmaps exist for installation $NAME"
do_get 'networkpolicies.txt' kube_describe_by_label networkpolicies || log "no networkpolicies exist for installation $NAME"
do_get 'events.txt' kube_get_events || log "no events exist for installation $NAME"

for app in ${LOG_APPS[@]}; do
    do_get_logs "$app"
done

# check the presence of this var to see if we're supposed to zip
if [[ ! -z "$ZIP_OUTPUT_FILE" ]]; then
    log "zipping output directory: '${OUTPUT_DIR}' to '${ZIP_OUTPUT_FILE}'"
    zip -j -r "$ZIP_OUTPUT_FILE" "$OUTPUT_DIR"
fi

cleanup_tempdir
