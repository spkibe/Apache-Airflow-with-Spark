FROM apache/airflow:2.10.0

USER root

# Install dependencies for Java and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-17-jdk procps && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables for Java and Spark
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
ENV SPARK_HOME="/opt/spark"
ENV PATH="${PATH}:${JAVA_HOME}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin"

# Download and extract Spark
RUN mkdir -p ${SPARK_HOME} && \
    curl -fsSL https://archive.apache.org/dist/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz -o spark.tgz && \
    tar -xvzf spark.tgz --directory ${SPARK_HOME} --strip-components 1 && \
    rm spark.tgz

# Copy Spark configuration
COPY spark-defaults.conf ${SPARK_HOME}/conf/

# Set ownership
RUN chown -R airflow ${SPARK_HOME}

USER airflow

# Install Airflow Spark provider
RUN pip install --no-cache-dir apache-airflow-providers-apache-spark