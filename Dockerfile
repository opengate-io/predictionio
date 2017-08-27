FROM ubuntu
MAINTAINER DUONG Dinh Cuong <cuong3ihut@gmail.com>

ENV PIO_VERSION 0.11.0
ENV SPARK_VERSION 1.6.3
ENV POSTGRES_VERSION 42.1.4
ENV HADOOP_VERSION 2.6

ENV POSTGRESQL_DATABASE=postgresql
ENV ELASTICSEARCH_HOSTS=elasticsearch
ENV STORAGE_BASEDIR=/opt/PredictionIO

ENV PIO_HOME /PredictionIO-${PIO_VERSION}-incubating
ENV PATH=${PIO_HOME}/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV SPARK_MASTER_IP spark-cluster-ip.pickover.one
ENV SPARK_MASTER_PORT 7077
ENV SPARK_DRIVER_MEMORY 4G
ENV SPARK_EXECUTOR_MEMORY 8G

RUN apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl wget openjdk-8-jdk libgfortran3 python-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://www.apache.org/dist/incubator/predictionio/${PIO_VERSION}-incubating/apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
    && tar -xvzf apache-predictionio-${PIO_VERSION}-incubating.tar.gz -C / && rm apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
    && ./make-distribution.sh \
    && tar zxvf PredictionIO-${PIO_VERSION}-incubating.tar.gz -C / && mkdir -p ${PIO_HOME}/vendors \
    && rm -rf /apache-predictionio-${PIO_VERSION}-incubating
COPY files/pio-env.sh ${PIO_HOME}/conf/pio-env.sh
COPY files/bin/pio-start-all ${PIO_HOME}/bin/pio-start-all
COPY files/bin/pio-stop-all ${PIO_HOME}/bin/pio-stop-all
COPY files/bin/pio-train ${PIO_HOME}/bin/pio-train

RUN curl -O https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C ${PIO_HOME}/vendors/ \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

RUN wget https://jdbc.postgresql.org/download/postgresql-${POSTGRES_VERSION}.jar -P ${PIO_HOME}/lib/

RUN ln -s ${PIO_HOME} /PredictionIO \
    && chmod +x ${PIO_HOME}/bin/pio-stop-all \
    && chmod +x ${PIO_HOME}/bin/pio-start-all \
    && chmod +x ${PIO_HOME}/bin/pio-train

#triggers fetching the complete sbt environment
RUN ${PIO_HOME}/sbt/sbt -batch && pip install --upgrade pip && pip install setuptools && pip install predictionio

VOLUME $STORAGE_BASEDIR
WORKDIR $STORAGE_BASEDIR

EXPOSE 8000 9000 7070

CMD ["pio", "eventserver", "--ip", "0.0.0.0"]
