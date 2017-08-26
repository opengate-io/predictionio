FROM ubuntu
MAINTAINER DUONG Dinh Cuong <cuong3ihut@gmail.com>

ENV PIO_VERSION 0.11.0
ENV SPARK_VERSION 1.6.3
ENV POSTGRES_VERSION 42.1.4
ENV HADOOP_VERSION 2.6

ENV PIO_HOME /PredictionIO-${PIO_VERSION}-incubating
ENV PATH=${PIO_HOME}/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl openjdk-8-jdk libgfortran3 python-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://www.apache.org/dist/incubator/predictionio/${PIO_VERSION}-incubating/apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
    && tar -xvzf apache-predictionio-${PIO_VERSION}-incubating.tar.gz -C / && rm apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
    && cd apache-predictionio-${PIO_VERSION}-incubating \
    && sh make-distribution.sh \
    && tar zxvf PredictionIO-${PIO_VERSION}-incubating.tar.gz -C / && mkdir -p ${PIO_HOME}/vendors \
    && rm -rf /apache-predictionio-${PIO_VERSION}-incubating
COPY files/pio-env.sh ${PIO_HOME}/conf/pio-env.sh
COPY files/bin/pio-start-all ${PIO_HOME}/bin/pio-start-all
COPY files/bin/pio-stop-all ${PIO_HOME}/bin/pio-stop-all

RUN wget https://jdbc.postgresql.org/download/postgresql-${POSTGRES_VERSION}.jar ${PIO_HOME}/lib

RUN ln -s ${PIO_HOME} /PredictionIO \
    && chmod +x ${PIO_HOME}/bin/pio-stop-all \
    && chmod +x ${PIO_HOME}/bin/pio-start-all

RUN curl -O https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP-VERSION}.tgz \
    && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP-VERSION}.tgz -C ${PIO_HOME}/vendors \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP-VERSION}.tgz

#triggers fetching the complete sbt environment
RUN ${PIO_HOME}/sbt/sbt -batch && pip install --upgrade pip && pip install setuptools && pip install predictionio

VOLUME /opt/PredictionIO
WORKDIR /opt/PredictionIO/

EXPOSE 8000 9000 7070

CMD ["pio", "eventserver", "--ip", "0.0.0.0"]
