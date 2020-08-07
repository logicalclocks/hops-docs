.. _cluster-definitions:

==================================
Customized Installations
==================================

A Hopsworks installation is performed using a cluster definition, written as a YML file. Both :ref:`hopsworks-cloud-installer` and :ref:`hopsworks-installer` will create a cluster definition file that is used to perform the installation, populating it with IP addresses for nodes, and auto-generated credentials for services. An example of a cluster definition is provided below that will install Hopsworks on 3 servers (VMs). You can have a single host installation of Hopsworks where there is only 1 group section for the head VM or, below, we have a 3-node Hopsworks cluster where the  head VM will contain most of the services with the execution of runing jobs - they will run on the GPU workers (2 of them are in this cluster definition). You can, of course, add more workers and install different services on different VMs. You may also want to configure services. If you want to configure the installation of services in Hopsworks, you will need to edit the cluster definition before it is installed.

In the example, below, we configure the database, NDB, to have 16 threads and 16GB of memory. We also configure the workers to install Cuda and give 16 CPUs/48 GBs of RAM to the YARN nodemanagers. There are many hundreds of other attributes that can be configured for the different services in Hopsworks, and they can be found in the respective Chef cookbook for the service.
You can configure any given service by first looking up its Chef cookbook on the Logical Clocks GitHub repository (https://github.com/logicalclocks), see :ref:`chef-cookbooks`, and then finding the available attributes in a file called metadata.rb in the root directory. The new values for the attribute can be either added to global scope at the start of the cluster definition - meaning they will be applied to all hosts in the cluster - or at the individual group level (such as the cuda and hops attributes defined in the example below).


.. literalinclude:: cluster.yml
		      :language: YML


			 
The cluster definition is installed by `Karamel <http://www.karamel.io/>`_ that connects to the VMs using SSH and installs the services using Chef cookbooks. There is no need to install a Chef server, as Karamel runs the Chef cookbooks using chef-solo. That is, Karamel only needs SSH and sudo access to be able to install Hopsworks services on the target VMs. Karamel downloads the Chef cookbooks (by default from Github), checks the attributes in the cookbooks are valid (by ensuring they are defined in the metadata.rb file for the cookbook) and executes chef-solo to run a  program (*recipe*) that contains instructions for how to install and configure the software service.  Karamel also provides dependency injection for Chef recipes, supplying parameters (*Chef attributes*) used to execute the recipes. Some recipes can also return results (such as the IP address of a service) that are used in subsequent recipes (for example, to generate configuration files for multi-host services (like HopsFS and NDB).

.. _chef-cookbooks:

Chef Cookbooks
------------------------

The following is a brief description of the Chef cookbooks that we have developed to support the installation of Hopsworks. The recipes have the naming convention: <cookbook>/<recipe>. You can determine the URL for each cookbook by prefixing the name with http://github.com/. All of the recipes have been *karamelized*, that is a Karamelfile containing orchestration rules has been added to all cookbooks to ensure that the services are installed in the correct order.


* logicalclocks/hops-hadoop-chef

   * This cookbook contains recipes for installing the Hops Hadoop services: HopsFS NameNode (hops::nn), HopsFS DataNode (hops::dn), YARN ResourceManager (hops::rm), YARN NodeManager (hops::nm), Hadoop Job HistoryServer for MapReduce (hops::jhs), Hadoop ProxyServer (hops::ps). 

* logicalclocks/ndb-chef

   * This cookbook contains recipes for installing MySQL Cluster services: NDB Management Server (ndb::mgmd), NDB Data Node (ndb::ndbd), MySQL Server (ndb::mysqld), Memcached for MySQL Cluster (ndb::memcached).

* logicalclocks/hopsworks-chef

   * This cookbook contains a default recipe for installing Hopsworks.

* logicalclocks/spark-chef

   * This cookbook contains recipes for installing the Apache Spark Master, Worker, and a YARN client.

* logicalclocks/flink-chef

   * This cookbook contains recipes for installing the Apache Flink jobmanager, taskmanager, and a YARN client.

* logicalclocks/elasticsearch-chef

   * This cookbook is a wrapper cookbook for the official Elasticsearch Chef cookbook, but it has been extended with Karamel orchestration rules.

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
     
* logicalclocks/kagent-chef

   * This cookbook contains recipes for installing kagent, a python service run on Hopsworks servers for management operations.

* logicalclocks/conda-chef

   * This cookbook contains recipes for installing conda on Hopsworks servers.

