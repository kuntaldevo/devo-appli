#!/usr/bin/env bash

# Runs as a cron job in the shared dev cluster to automatically shut down installations that have been active for a configurable period.
# This will not delete the installations, but merely stop them

set -e

SHUTDOWN_ANNOTATION="paxata.com/installation-shutdown-at"
SHUTDOWN_JSON_PATCH='[{"op":"remove","path":"/metadata/annotations/paxata.com~1installation-shutdown-at"},{"op":"replace","path":"/spec/active","value":false}]'
LIST_JSON_PATH="{range .items[*]}{.spec.active}{' '}{.metadata.namespace}{' '}{.metadata.name}{' '}{.metadata.annotations['paxata\.com/installation-shutdown-at']}{'\n'}{end}"

# default the idle timeout to 4 hours if unset
: "${INSTALLATION_IDLE_TIME_SECONDS:=14400}"

function log() {
    echo "[$(date)] - $@"
}

function set_annotation() {
    local namespace="$1"
    local name="$2"
    local now="$(date +%s)"
    local shutdown_at=$(($now + $INSTALLATION_IDLE_TIME_SECONDS))

    log "Setting annotation on installation $namespace/$name,  ${SHUTDOWN_ANNOTATION}: ${shutdown_at}"

    kubectl -n ${namespace} patch pax ${name} --type merge -p "{\"metadata\":{\"annotations\":{\"${SHUTDOWN_ANNOTATION}\":\"${shutdown_at}\"}}}"
}

function shutdown_installation() {
    local namespace="$1"
    local name="$2"

    if [[ -z "$DRY_RUN" ]]; then
        kubectl -n "$namespace" patch pax "$name" --type json -p "$SHUTDOWN_JSON_PATCH"
        log "Successfully shutdown installation ${namespace}/${name}"

    else
        log "Not shutting down ${namespace}/${name} because DRY_RUN is set"
    fi
}

function maybe_deactivate() {
    local namespace="$1"
    local name="$2"
    local shutdown_at_value="$3"

    log "Checking to see if ${namespace}/${name} should be shutdown"

    # local shutdown_at_value=$(kubectl -n ${namespace} get pax ${name} -o=jsonpath="{.metadata.annotations['$SHUTDOWN_ANNOTATION']}")

    log "$SHUTDOWN_ANNOTATION for ${namespace}/${name}: '$shutdown_at_value'"

    if [[ $(echo "$shutdown_at_value" | grep -E "^\d+$") ]]; then
        # This installation has been annotated with a shutdown time, so we'll check to see if it should be shutdown
        local now="$(date +%s)"
        if [[ "$now" -gt "$shutdown_at_value" ]]; then
            log "Will attempt to shutdown installation ${namespace}/${name} because the annotated shutdown time of '${shutdown_at_value}' is less than the current time '$now'"
            shutdown_installation "$namespace" "$name"
        else
            log "Not shutting down installation ${namespace}/${name} because the annotated shutdown time of '${shutdown_at_value}' is greater than the current time '$now'"
        fi

    else
        # The annotation was not present or malformed, so we'll set the shutdown-at annotation
        set_annotation "$namespace" "$name"
    fi
}

function remove_annotation() {
    local namespace="$1"
    local name="$2"

    kubectl -n "$namespace" annotate pax "$name" "${SHUTDOWN_ANNOTATION}-"
    log "successfully removed annotation from ${namespace}/${name}"
}

ALL_INSTALLS=$(kubectl get pax --all-namespaces -o=jsonpath="$LIST_JSON_PATH")
while read active namespace name shutdown_at ; do
    log "Processing install ${namespace}/${name} - active: ${active}, shutdown_at: '${shutdown_at}'"

    if [[ "$active" == "true" ]]; then
        maybe_deactivate "$namespace" "$name" "$shutdown_at"
    else
        if ! [[ -z "$shutdown_at" ]]; then
            log "removing annotation from ${namespace}/${name}"
            remove_annotation "$namespace" "$name"
        fi
    fi
done <<< "$ALL_INSTALLS"
