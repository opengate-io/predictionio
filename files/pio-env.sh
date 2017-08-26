#!/usr/bin/env bash

PIO_FS_BASEDIR=${HOME}/.pio_store
PIO_FS_ENGINESDIR=${PIO_FS_BASEDIR}/engines
PIO_FS_TMPDIR=${PIO_FS_BASEDIR}/tmp

SPARK_HOME=${PIO_HOME}/vendors/spark-${SPARK_VERSION}-bin-hadoop2.6

# Filesystem paths where PredictionIO uses as block storage.
PIO_FS_BASEDIR=$HOME/.pio_store
PIO_FS_ENGINESDIR=$PIO_FS_BASEDIR/engines
PIO_FS_TMPDIR=$PIO_FS_BASEDIR/tmp

# PredictionIO Storage Configuration
#
# This section controls programs that make use of PredictionIO's built-in
# storage facilities. Default values are shown below.

# Storage Data Sources
PIO_STORAGE_SOURCES_LOCALFS_TYPE=localfs
PIO_STORAGE_SOURCES_LOCALFS_PATH=$PIO_FS_BASEDIR/models

PIO_STORAGE_SOURCES_HBASE_TYPE=hbase
PIO_STORAGE_SOURCES_HBASE_HOME=$PIO_HOME/vendors/hbase-1.0.0

# Storage Data Sources (pgsql)
PIO_STORAGE_SOURCES_PGSQL_TYPE=jdbc
PIO_STORAGE_SOURCES_PGSQL_URL=jdbc:postgresql://predictionio-database:5432/postgresql

PIO_STORAGE_SOURCES_PGSQL_USERNAME=postgres
PIO_STORAGE_SOURCES_PGSQL_PASSWORD=predictionio

# Storage Repositories
PIO_STORAGE_REPOSITORIES_METADATA_NAME=predictionio_metadata
PIO_STORAGE_REPOSITORIES_METADATA_SOURCE=PGSQL

PIO_STORAGE_REPOSITORIES_MODELDATA_NAME=predictionio_modeldata
PIO_STORAGE_REPOSITORIES_MODELDATA_SOURCE=PGSQL

PIO_STORAGE_REPOSITORIES_EVENTDATA_NAME=predictionio_eventdata
PIO_STORAGE_REPOSITORIES_EVENTDATA_SOURCE=PGSQL