FROM apache/airflow:2.7.3-python3.11

USER root

RUN apt-get update && \
    apt-get install -y gcc python3-dev openjdk-11-jdk && \
    apt-get clean

# ✅ Correct for most x86_64 machines
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

USER airflow

# ✅ Only install spark provider, not Airflow again!
RUN pip install apache-airflow-providers-apache-spark pyspark
