#!/bin/sh
set -e

/opt/eap/bin/jboss-cli.sh --file=/extensions/scripts/actions.cli

exec "$@"