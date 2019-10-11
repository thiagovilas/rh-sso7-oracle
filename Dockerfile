FROM registry.access.redhat.com/redhat-sso-7/sso73-openshift

USER root

## Add Oracle JAR to /extensions directory
ARG FILE_NAME=ojdbc7.jar
# RUN mkdir /extensions && curl -o /extensions/${FILE_NAME}  https://example.com/${FILE_NAME}
ADD /extensions /extensions
ADD actions.cli /extensions/scripts/actions.cli
ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod -R 777 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000 8443

USER jboss

