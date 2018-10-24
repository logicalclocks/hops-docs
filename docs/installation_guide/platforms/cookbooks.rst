===========================
Hopsworks Chef Cookbooks
===========================

Hopsworks' automated installation is orchestrated by Karamel and the installation/configuration logic is written as ruby programs in Chef. Chef supports the modularization of related programs in a unit of software, called a Chef *cookbook*. A Chef cookbook can be seen as a collection of programs, where each program contains instructions for how to install and configure software services. A cookbook may consist one or more programs that are known as *recipes*. These Chef recipes are executed by either a Chef client (that can talk to a Chef server) or chef-solo, a standalone program that has no dependencies on a Chef Server. Karamel uses chef-solo to execute Chef recipes on nodes. The benefit of this approach is that it is agentless. That is, Karamel only needs ssh to be installed on the target machine to be able to install and setup Hopsworks. Karamel also provides dependency injection for Chef recipes, supplying the parameters (*Chef attributes*) used to execute recipes. Some stages/recipes return results (such as the IP address of the NameNode) that are used in subsequent recipes (for example, to generate configuration files containing the IP address of the NameNode, such as core-site.xml).

The following is a brief description of the Chef cookbooks that we have developed to support the installation of Hopsworks. The recipes have the naming convention: <cookbook>/<recipe>. You can determine the URL for each cookbook by prefixing the name with http://github.com/. All of the recipes have been *karamelized*, that is a Karamelfile containing orchestration rules has been added to all cookbooks.




* logicalclocks/hops-hadoop-chef

   * This cookbook contains recipes for installing the Hops Hadoop services: HopsFS NameNode (hops::nn), HopsFS DataNode (hops::dn), YARN ResourceManager (hops::rm), YARN NodeManager (hops::nm), Hadoop Job HistoryServer for MapReduce (hops::jhs), Hadoop ProxyServer (hops::ps). 

* logicalclocks/ndb-chef

   * This cookbook contains recipes for installing MySQL Cluster services: NDB Management Server (ndb::mgmd), NDB Data Node (ndb::ndbd), MySQL Server (ndb::mysqld), Memcached for MySQL Cluster (ndb::memcached).

* logicalclocks/zeppelin-chef

   * This cookbook contains a default recipe for installing Apache Zeppelin.

* logicalclocks/hopsworks-chef

   * This cookbook contains a default recipe for installing Hopsworks.

* logicalclocks/spark-chef

   * This cookbook contains recipes for installing the Apache Spark Master, Worker, and a YARN client.

* logicalclocks/flink-chef

   * This cookbook contains recipes for installing the Apache Flink jobmanager, taskmanager, and a YARN client.

* logicalclocks/elasticsearch-chef

   * This cookbook is a wrapper cookbook for the official Elasticsearch Chef cookbook, but it has been extended with Karamel orchestration rules.

* logicalclocks/dr-elephant-chef

   * This cookbook contains recipes for installing Dr Elephant.

* logicalclocks/livy-chef

   * This cookbook contains recipes for installing Livy REST Server for Spark.

* logicalclocks/epipe-chef

   * This cookbook contains recipes for installing ePipe, exporting HopsFS' namespace to Elasticsearch for free-text search of the HDFS namespace.

* logicalclocks/dela-chef

   * This cookbook contains recipes for installing dela, the peer-to-peer tool for sharing datasets in Hopsworks.

* logicalclocks/hopsmonitor-chef

   * This cookbook contains recipes for installing  InfluxDB, Grafana, Telegraf, and Kapacitor.

* logicalclocks/hopslog-chef

   * This cookbook contains recipes for installing Kibana, Filebeat and Logstash.
     
* logicalclocks/tensorflow-chef

   * This cookbook contains recipes for installing TensorFlow to work with Hopsworks.

* logicalclocks/airflow-chef

   * This cookbook contains recipes for installing Airflow to work with Hopsworks.
     
