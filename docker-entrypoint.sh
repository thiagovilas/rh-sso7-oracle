#!/bin/sh
# Openshift EAP launch script

source ${JBOSS_HOME}/bin/launch/openshift-common.sh
source $JBOSS_HOME/bin/launch/logging.sh
source $JBOSS_HOME/bin/launch/configure.sh


set -e

/opt/eap/bin/jboss-cli.sh --file=/extensions/scripts/actions.cli
/opt/eap/bin/openshift-launch.sh;

exec "$@"