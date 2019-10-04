FROM redhat-sso-7/sso72-openshift

USER root

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY /extensions /extensions 

## Add Oracle JAR to /extensions directory
ARG FILE_NAME=ojdbc7.jar
RUN mkdir /extensions && curl -o /extensions/${FILE_NAME}  https://example.com/${FILE_NAME}

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000 8443

USER jboss
