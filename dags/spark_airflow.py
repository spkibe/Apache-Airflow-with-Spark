from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator
from datetime import datetime

default_args = {
    'owner': 'kibet',
    'start_date': datetime(2025, 7, 28),
    'retries': 1,
    'retry_delay': datetime(2025, 7, 28)
}

dag = DAG(
    'spark_airflow_dag',
    default_args=default_args,
    schedule_interval='@daily',
    catchup=False
)

start = PythonOperator(
    task_id='start',
    python_callable=lambda: print('Spark Airflow DAG started'),
    dag=dag
)

python_job = SparkSubmitOperator(
    task_id='python_job',
    application='/opt/airflow/jobs/python/word_count_job.py',
    conn_id='spark-conn',
    dag=dag
)
end = PythonOperator(
    task_id='end',
    python_callable=lambda: print('Spark Airflow DAG completed'),
    dag=dag
)

start >> python_job >> end