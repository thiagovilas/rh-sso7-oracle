# rh-sso7-oracle
Deploy RH SSO and Oracle database on local Docker

# Prerequisites
Verify if you have access to RH SSO Image

https://access.redhat.com/containers/#/registry.access.redhat.com/redhat-sso-7/sso73-openshift

Download Oracle Docker Container in your local environment, check the URL below, is necessary to accept Oracle terms:

https://hub.docker.com/_/oracle-database-enterprise-edition

Download Oracle JDBC driver adding it to the /extensions folder.

https://www.oracle.com/database/technologies/jdbc-drivers-12c-downloads.html

Overwrite /extension/truststore.jks if you need use any specific certificate
keytool -genkey -alias localhost -keyalg RSA -keystore ./extensions/truststore.jks -validity 10950

# Description
This repository contains a container to deploy RH SSO  accessing external Oracle database. To do so, it calls a script which is mounted under /extensions/scripts. This script will configure properly the standalone.xml file contained in the image to add the datasource. It also adds your own truststore.

# Commands
Pull Oracle Image store/oracle/database-enterprise:12.2.0.1

Create a Docker network

```bash
$ docker network create rh-sso-net
```

Run Oracle Image
```bash
$ docker run -d -it --name oracle-db-rh-sso --network=rh-sso-net -p 1521:1521 -e DB_SID=RHSSO store/oracle/database-enterprise:12.2.0.1
```

Access SQL Plus
```bash
$ docker exec -it oracle-db-rh-sso bash -c "source /home/oracle/.bashrc; sqlplus /nolog"
```

Execute the Following SQL Commands

```sql
connect sys/Oradoc_db1 as sysdba

alter session set "_ORACLE_SCRIPT"=true;

CREATE USER RHSSO IDENTIFIED BY RHSSO;

GRANT CONNECT TO "RHSSO";
GRANT SELECT ON "SYS"."PENDING_TRANS$" TO "RHSSO";
GRANT SELECT ON "SYS"."DBA_2PC_PENDING" TO "RHSSO";
GRANT EXECUTE ON "SYS"."DBMS_XA" TO "RHSSO";
GRANT SELECT ON "SYS"."DBA_PENDING_TRANSACTIONS" TO "RHSSO";
GRANT RESOURCE TO "RHSSO";
ALTER USER "RHSSO" QUOTA UNLIMITED ON USERS;
```

Build Image
```bash
$ docker build . -t rh-sso7-oracle
```


Run Oracle SSO Image

```bash
$ docker run -d --name rh-sso7-oracle -p 8080:8080  --network=rh-sso-net \
-e ORACLE_SERVICE_NAME=RHSSO.localdomain  \
-e ORACLE_USERNAME=RHSSO \
-e ORACLE_PASSWORD=RHSSO \
-e ORACLE_SERVICE_HOST=oracle-db-rh-sso \
-e ORACLE_SERVICE_PORT=1521 \
-e SSO_ADMIN_PASSWORD=sso123 \
-e SSO_ADMIN_USERNAME=ssouser \
-e JGROUPS_CLUSTER_PASSWORD=cluster123 \
rh-sso7-oracle:latest
```


