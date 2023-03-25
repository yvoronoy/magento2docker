ARG M2D_DB_ENGINE_VENDOR='mariadb'
ARG M2D_DB_ENGINE_VERSION='10.2'

FROM mariadb:10.4 AS m2d_db_engine_mariadb_10

FROM mariadb:10.2 AS m2d_db_engine_mariadb_10.2
FROM mariadb:10.3 AS m2d_db_engine_mariadb_10.3
FROM mariadb:10.4 AS m2d_db_engine_mariadb_10.4
FROM mariadb:10.6 AS m2d_db_engine_mariadb_10.6

FROM --platform=linux/amd64 mysql:5.7 AS m2d_db_engine_mysql_5
FROM --platform=linux/amd64 mysql:8.0.28 AS m2d_db_engine_mysql_8

FROM --platform=linux/amd64 mysql:5.7 AS m2d_db_engine_mysql_5.7
FROM --platform=linux/amd64 mysql:8.0.28 AS m2d_db_engine_mysql_8.0
FROM mysql:8.0.28-oracle AS m2d_db_engine_mysql_8.0-oracle

FROM m2d_db_engine_${M2D_DB_ENGINE_VENDOR}_${M2D_DB_ENGINE_VERSION} AS m2d_db_engine
COPY services/db-engines/etc/mysql/my.cnf /etc/mysql/conf.d
