FROM registry.access.redhat.com/redhat-sso-7/sso73-openshift

USER root

## Add Oracle JAR to /extensions directory
ARG FILE_NAME=ojdbc7.jar

ADD /extensions /extensions
ADD actions.cli /extensions/scripts/actions.cli
ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod a+x -R /docker-entrypoint.sh

EXPOSE 8000 8443

USER jboss

ENTRYPOINT ["/docker-entrypoint.sh"]

