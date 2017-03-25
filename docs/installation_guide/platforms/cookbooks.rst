===========================
Hops Chef Cookbooks
===========================

Hops' automated installation is orchestrated by Karamel and the installation/configuration logic is written as ruby programs in Chef. Chef supports the modularization of related programs in a unit of software, called a Chef *cookbook*. A Chef cookbook can be seen as a collection of programs, where each program contains instructions for how to install and configure software services. A cookbook may consist one or more programs that are known as *recipes*. These Chef recipes are executed by either a Chef client (that can talk to a Chef server) or chef-solo, a standalone program that has no dependencies on a Chef Server. Karamel uses chef-solo to execute Chef recipes on nodes. The benefit of this approach is that it is agentless. That is, Karamel only needs ssh to be installed on the target machine to be able to install and setup Hops. Karamel also provides dependency injection for Chef recipes, supplying the parameters (*Chef attributes*) used to execute recipes. Some stages/recipes return results (such as the IP address of the NameNode) that are used in subsequent recipes (for example, to generate configuration files containing the IP address of the NameNode, such as core-site.xml).

The following is a brief description of the Chef cookbooks that we have developed to support the installation of Hops. The recipes have the naming convention: <cookbook>/<recipe>. You can determine the URL for each cookbook by prefixing the name with http://github.com/. All of the recipes have been *karamelized*, that is a Karamelfile containing orchestration rules has been added to all cookbooks.


* hopshadoop/apache-hadoop-chef

   * This cookbook contains recipes for installing the Apache Hadoop services: HDFS NameNode (hadoop::nn), HDFS DataNode (hadoop::dn), YARN ResourceManager (hadoop::rm), YARN NodeManager (hadoop::nm), Hadoop Job HistoryServer for MapReduce (hadoop::jhs), Hadoop ProxyServer (hadoop::ps).

* hopshadoop/hops-hadoop-chef

   * This cookbook contains is a wrapper cookbook for the Apache Hadoop cookbook. It install Hops, but makes use of the Apache Hadoop Chef cookbook to install and configure software. The recipes it provides are: HopsFS NameNode (hops::nn), HopsFS DataNode (hops::dn), HopsYARN ResourceManager (hops::rm), HopsYARN NodeManager (hops::nm), Hadoop Job HistoryServer for MapReduce (hops::jhs), Hadoop ProxyServer (hops::ps).

* hopshadoop/elasticsearch-chef

   * This cookbook is a wrapper cookbook for the official Elasticsearch Chef cookbook, but it has been extended with Karamel orchestration rules.

* hopshadoop/ndb-chef

   * This cookbook contains recipes for installing MySQL Cluster services: NDB Management Server (ndb::mgmd), NDB Data Node (ndb::ndbd), MySQL Server (ndb::mysqld), Memcached for MySQL Cluster (ndb::memcached).

* hopshadoop/zeppelin-chef

   * This cookbook contains a default recipe for installing Apache Zeppelin.

* hopshadoop/hopsworks-chef

   * This cookbook contains a default recipe for installing HopsWorks.

* hopshadoop/spark-chef

   * This cookbook contains recipes for installing the Apache Spark Master, Worker, and a YARN client.

* hopshadoop/flink-chef

   * This cookbook contains recipes for installing the Apache Flink jobmanager, taskmanager, and a YARN client.

* hopshadoop/dr-elephant-chef

   * This cookbook contains recipes for installing Dr Elephant.

* hopshadoop/livy-chef

   * This cookbook contains recipes for installing Livy REST Server for Spark.

* hopshadoop/epipe-chef

   * This cookbook contains recipes for installing ePipe, exporting HopsFS' namespace to Elasticsearch for free-text search of the HDFS namespace.

* hopshadoop/dela-chef

   * This cookbook contains recipes for installing dela, the peer-to-peer tool for sharing datasets in Hopsworks.

* hopshadoop/hopsmonitor-chef

   * This cookbook contains recipes for installing tools for logging streaming applications - Kibana and Logstash.

* hopshadoop/tensorflow-chef

   * This cookbook contains recipes for installing tensorflow to work with Hopsworks and Zeppelin.
