==========================
Security Requirements
==========================

Hopsworks and Hops require good network support for data intensive computation. 


The following components are supported by TLS version 1.2+:

* Hopsworks, Feature Store  
* Hops (HopsFS, YARN, JobHistoryServer)
* Apache Kafka
* MySQL Server
* Elastic, Logstash, Filebeat
* Apache Zookeeper
* Apache Hive
* Apache Flink    
* Apache Spark, Spark History Server
* Apache Livy
* Prometheus    
* Jupyter

Hopsworks uses different user accounts and groups to run services. The actual user accounts and groups needed depends on the services you install. Do not delete these accounts or groups and do not modify their permissions and rights. Ensure that no existing systems prevent these accounts and groups from functioning. For example, if you have scripts that delete user accounts not in a whitelist, add these accounts to the list of permitted accounts. Hopsworks creates and uses the following accounts and groups:  

+-------------------+------------+-----------+----------------------+
| Service           |Unix User ID| Group     | Description          |
+===================+============+===========+======================+
| namenode          | hdfs       | hadoop    |                      |
+-------------------+------------+-----------+----------------------+ 
| datanode          | hdfs       | hadoop    |                      |
+-------------------+------------+-----------+----------------------+ 
| resourcemgr       | yarn       | hadoop    |                      |
+-------------------+------------+-----------+----------------------+ 
| nodemanager       | yarn       | hadoop    |                      |
+-------------------+------------+-----------+----------------------+ 
| hopsworks         | glassfish  | glassfish |                      |
+-------------------+------------+-----------+----------------------+ 
| elasticsearch     | elastic    | elastic   |                      |
+-------------------+------------+-----------+----------------------+ 
| logstash          | elastic    | elastic   |                      |
+-------------------+------------+-----------+----------------------+ 
| filebeat          | elastic    | elastic   |                      |
+-------------------+------------+-----------+----------------------+ 
| kibana            | kibana     | elastic   |                      |
+-------------------+------------+-----------+----------------------+ 
| ndmtd             | mysql      | mysql     |                      |
+-------------------+------------+-----------+----------------------+ 
| mysqld            | mysql      | mysql     |                      |
+-------------------+------------+-----------+----------------------+ 
| ndb_mgmd          | mysql      | mysql     |                      |
+-------------------+------------+-----------+----------------------+ 
| hiveserver2       | hive       | hive      |                      |
+-------------------+------------+-----------+----------------------+ 
| metastore         | hive       | hive      |                      |
+-------------------+------------+-----------+----------------------+ 
| kafka             | kafka      | kafka     |                      |
+-------------------+------------+-----------+----------------------+ 
| zookeeper         | zookeeper  | zookeeper |                      |
+-------------------+------------+-----------+----------------------+ 
| epipe             | epipe      | epipe     |                      |
+-------------------+------------+-----------+----------------------+ 
| kibana            | kibana     | kibana    |                      |
+-------------------+------------+-----------+----------------------+ 
| airflow-scheduler | airflow    | airflow   |                      |
+-------------------+------------+-----------+----------------------+ 
| sqoop             | airflow    | airflow   |                      |
+-------------------+------------+-----------+----------------------+ 
| airflow-webserver | airflow    | airflow   |                      |
+-------------------+------------+-----------+----------------------+ 
