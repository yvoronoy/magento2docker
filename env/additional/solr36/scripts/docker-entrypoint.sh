#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- solr "$@"
fi

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

# configure Solr to run on the local interface, and start it running in the background
function initial_solr_begin {
    echo "Configuring Solr to bind to 127.0.0.1"
    cd /opt/solr/example/ && java -jar start.jar
    max_try=${MAX_TRY:-5}
    wait_seconds=${WAIT_SECONDS:-5}
    if ! /opt/docker-solr/scripts/wait-for-solr.sh "$max_try" "$wait_seconds"; then
        echo "Could not start Solr."
        if [ -f /opt/solr/server/logs/solr.log ]; then
            echo "Here is the log:"
            cat /opt/solr/server/logs/solr.log
        fi
        exit 1
    fi
}

initial_solr_begin

exec "$@"