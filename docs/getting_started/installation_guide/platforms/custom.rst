.. _cluster-definitions:

Custom Installation
==================================

A custom installation of Hopsworks allows you to change the set of installed services, configure resources for services, configure username/passwords, change installation directories, and so on. A Hopsworks installation is performed using a cluster definition in a `YML file`. Both :ref:`hopsworks-cloud-installer` and :ref:`hopsworks-installer` will create a cluster definition file in `cluster-defns/hopsworks-installation.yml` that is used for installation. The installation scripts populate this YML file with IP addresses for services, auto-generated credentials for services, and configuration options for services.


An example of a cluster definition file is provided below that will install Hopsworks on 3 servers (VMs). You can have a single host installation of Hopsworks where there is only 1 group section for the head VM or, below, we have a 3-node Hopsworks cluster where the  head VM will contain most of the services with the execution of runing jobs - they will run on the GPU workers (2 of them are in this cluster definition). You can, of course, add more workers and install different services on different VMs. You may also want to configure services. If you want to configure the installation of services in Hopsworks, you will need to edit the cluster definition before it is installed.

In the example, below, we configure the database, NDB, to have 16 threads and 16GB of memory. We also configure the workers to install Cuda and give 16 CPUs/48 GBs of RAM to the YARN nodemanagers. There are many hundreds of other attributes that can be configured for the different services in Hopsworks, and they can be found in the respective Chef cookbook for the service.
You can configure any given service by first looking up its Chef cookbook on the Logical Clocks GitHub repository (https://github.com/logicalclocks), see :ref:`chef-cookbooks`, and then finding the available attributes in a file called metadata.rb in the root directory. The new values for the attribute can be either added to global scope at the start of the cluster definition - meaning they will be applied to all hosts in the cluster - or at the individual group level (such as the cuda and hops attributes defined in the example below).


.. literalinclude:: cluster.yml
        :language: YAML


			 
The cluster definition is installed by :ref:`karamel-installer` that connects to the VMs using SSH and installs the services using Chef cookbooks. There is no need to install a Chef server, as Karamel runs the Chef cookbooks using chef-solo. That is, Karamel only needs SSH and sudo access to be able to install Hopsworks services on the target VMs. Karamel downloads the Chef cookbooks (by default from Github), checks the attributes in the cookbooks are valid (by ensuring they are defined in the metadata.rb file for the cookbook) and executes chef-solo to run a  program (*recipe*) that contains instructions for how to install and configure the software service.  Karamel also provides dependency injection for Chef recipes, supplying parameters (*Chef attributes*) used to execute the recipes. Some recipes can also return results (such as the IP address of a service) that are used in subsequent recipes (for example, to generate configuration files for multi-host services (like HopsFS and NDB).

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

* logicalclocks/consul-chef

   * This cookbook contains recipes for installing consul on Hopsworks servers.

* logicalclocks/kafka-cookbook

   * This cookbook contains recipes for installing Kafka.

* logicalclocks/kzookeeper

   * This cookbook contains recipes for installing Zookeeper.
     



     
System Requirements for Custom Clusters
---------------------------------------------

The recommended machine specifications given below are valid for either virtual machines or on-premises servers.

==========================
Hardware Requirements
==========================

CPU
---------------

Hopsworks contains many services and all run on x86 CPUs. It is recommended to have at least 8 CPUs for a single-server installation.


GPU
---------------

Hopsworks supports Nvidia Cuda version 11.x+ through Apache Hadoop YARN and Kubernetes.


=============================================
Operating System Requirements
=============================================

Hopsworks runs on the Linux operating system, and has been tested on the following Linux distributions:

* Ubuntu 18.04
* RedHat 7.6+
* Centos 7.6+

Hopsworks is not tested on other Linux distributions.


==========================
Database Requirements
==========================

Hopsworks and Hops require a MySQL compatible database.  MySQL Cluster (NDB) is the reccomended database. Hopsworks 1.4 requires at least the following version:

* MySQL Cluster 7.6+



==========================
Java Requirements
==========================

Hopsworks and Hops run on JDK 8, with only 64 bit JDKs are supported. JDK 9+ are not supported.

Supported JDKs:

* OpenJDK 1.8
* Oracle JDK 1.8

We recommend OpenJDK due to its more permissive open-source license.

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

Hopsworks uses different user accounts and groups to run services. The actual user accounts and groups needed depends on the services you install. Do not delete these accounts or groups and do not modify their permissions and rights. Ensure that no existing systems prevent these accounts and groups from functioning. For example, if you have configuration management tools then you need to whitelist Hopsworks users/groups. Hopsworks creates and uses the following accounts and groups:
The table below also provides the port a service is listening at. Not all services need to be accessible from
outside the cluster, therefore it is fine if the ports of such services are blocked by perimeter security. Services
that need to be accessible from outside the cluster are designated in the table below.


+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| Service           |Unix User ID| Group     | Ports                | External access                                                   |
+===================+============+===========+======================+===================================================================+
| namenode          | hdfs       | hadoop    | 8020, 50470          | Yes if external access to HopsFS is needed.                       |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| datanode          | hdfs       | hadoop    | 50010, 50020         | Yes if external access to HopsFS is needed.                       |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| resourcemgr       | rmyarn     | hadoop    | 8032                 | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| nodemanager       | yarn       | hadoop    | 8042                 | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| hopsworks         | glassfish  | glassfish | 443/8181, 4848       | Yes, only for 443/8181.                                           |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| elasticsearch     | elastic    | elastic   | 9200, 9300           | Yes if external applications need to read/write                   |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| logstash          | elastic    | elastic   | 5044-5052, 9600      | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| filebeat          | elastic    | elastic   |        N/A           | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| kibana            | kibana     | elastic   | 5601                 | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| ndbmtd            | mysql      | mysql     | 10000                | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| mysqld            | mysql      | mysql     | 3306                 | Yes if external online feature store access is required.          |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| ndb_mgmd          | mysql      | mysql     | 1186                 | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| hiveserver2       | hive       | hive      | 9085                 | Yes if working from SageMaker or an external Python environment   |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| metastore         | hive       | hive      | 9083                 | Yes if external access to the Feature Store is needed             |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| kafka             | kafka      | kafka     | 9091, 9092(external) | Yes for 9092 if external access to the Kafka cluster is needed    |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| zookeeper         | zookeeper  | zookeeper | 2181                 | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| epipe             | epipe      | epipe     |        N/A           | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| airflow-scheduler | airflow    | airflow   |        N/A           | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| sqoop             | airflow    | airflow   | 16000                | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| airflow-webserver | airflow    | airflow   | 12358                | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| kubernetes        | kubernetes | kubernetes| 6443                 | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| prometheus        | hopsmon    | hopsmon   | 9089                 | Yes if external access to job/system metrics is needed            |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| grafana           | hopsmon    | hopsmon   | 3000                 | Yes if external access to job/system metrics dashboards is needed |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| influxdb          | hopsmon    | hopsmon   | 9999                 | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| sparkhistoryserver| hdfs       | hdfs      | 18080                | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+
| flinkhistoryserver| flink      | flink     | 29183                | No                                                                |
+-------------------+------------+-----------+----------------------+-------------------------------------------------------------------+


==========================
Network Requirements
==========================

Hosts must satisfy the following networking and security requirements:

* IPv4 should be enabled, and, for Enterprise installations with Kubernetes, IPv6 must also be enabled.
* Cluster hosts must be able to resolve hostnames using either the /etc/hosts file or forward and reverse host resolution through DNS. The /etc/hosts files must be the same on all hosts, containing both hostnames and IP addresses. Hostnames should not contain uppercase letters and IP addresses must be unique. Hosts must not use aliases either in DNS or in the /etc/hosts files. 
* The installer must have SSH and sudo access to the hosts where you are installing Hopsworks' services.
* Disable or configure firewalls (e.g., iptables or firewalld) to allow access to ports used by Hopsworks' services.
* The hostname returned by the 'hostname' command in  RHEL and CentOS must be correct. (You can also find the hostname in /etc/sysconfig/network).


====================================================
Encrypted Data-at-Rest Requirements
====================================================

We recommend 

* Zfs-on-Linux 0.8.1+

  
==========================
Browser Requirements
==========================

We recommend for Hopsworks:

* Google Chrome

The following browsers work and are tested on all services, except the What-If-Tool (https://github.com/PAIR-code/what-if-tool), a Jupyter Plugin that only works on Chrome:
  
* Microsoft Edge
* Internet Explorer
* Firefox

    

==========================
Virtualization Support
==========================

You can run the entire Hopsworks stack on a single virtualbox instance for development or testing purposes, but you will need at least:

.. tabularcolumns:: {| p{\dimexpr 0.3\linewidth-2\tabcolsep} | p{\dimexpr 0.7\linewidth-2\tabcolsep}|}

==================   ================================
**Component**             **Minimum Requirements**
==================   ================================
Operating System      Linux, Mac, Windows (using Virtualbox)
RAM                   **16 GB of RAM (32 GB Recommended)**
CPU                   2 GHz dual-core minimum. 64-bit.
Hard disk space       50 GB free space
==================   ================================


Hopsworks runs on OpenStack and VMware, but currently it does not support GPUs on either Openstack or VMWare.


====================================
Recommended Setup
====================================

We recommend either Ubuntu/Debian or CentOS/Redhat as operating system (OS), with the same OS on all machines. A typical deployment of Hopsworks uses:

* DataNodes/NodeManagers: a set of commodity servers in a 12-24 SATA hard-disk JBOD setup;
* NameNodes/ResourceManagers: a homogeneous set of commodity (blade) servers with good CPUs, a reasonable amount of RAM, and one or two hard-disks;
* MySQL Cluster Data nodes: a homogeneous set of commodity (blade) servers with a good amount of RAM (up to 1 TB) and very good CPU(s). A good quality SATA disk is needed to store database logs. We also recommend at least 1 NVMe disk to store small files in HopsFS. More NVMe disks can be added later when more capacity for small files is needed.
* Hopsworks: a single commodity (blade) server with a good amount of RAM (up to 512 GB) and good CPU(s). A good quality disk is needed to store logs. Either SATA or a large SSD can be used.

For cloud platforms, such as AWS, we recommend using enhanced networking (25 Gb+) for the MySQL Cluster Data Nodes and the NameNodes/ResourceManagers. 


==================================================
Hopsworks on a single baremetal machine
==================================================

You can run the entire Hopsworks stack on a bare-metal single machine for development, testing or even production purposes, but you will need at least:

.. tabularcolumns:: {| p{\dimexpr 0.3\linewidth-2\tabcolsep} | p{\dimexpr 0.7\linewidth-2\tabcolsep}|}

==================   ================================
**Component**             **Minimum Requirements**
==================   ================================
Operating System      Linux, Mac
RAM                   16 GB of RAM
CPU                   2 GHz dual-core minimum. 64-bit.
Hard disk space       50 GB free space
==================   ================================


======================================================================================
NameNode, ResourceManager, NDB Data Nodes, Hopsworks, Kafka, and ElasticSearch
======================================================================================

NameNodes, ResourceManagers, NDB database nodes, ElasticSearch, and the Hopsworks application server require relatively more memory and not as much hard-disk space as DataNodes. The machines can be blade servers with only a disk or two. SSDs will not give significant performance improvements to any of these services, except the Hopsworks application server if you copy a lot of data in and out of the cluster via Hopsworks. The  NDB database nodes will require free disk space that is at least 20 times the size of the RAM they use. Depending on how large your cluster is, the ElasticSearch server and Kafka brokers can be colocated with the Hopsworks application server or moved to its own machine with lower RAM and CPU requirements than the other services.

1 GbE gives great performance, but 10 GbE really makes it rock! You can deploy 10 GbE incrementally: first between the NameNodes/ResourceManagers <--> NDB database nodes to improve metadata processing performance, and then on the wider cluster.

The recommended setup for these machines in production (on a cost-performance basis) is:

.. tabularcolumns:: {| p{\dimexpr 0.3\linewidth-2\tabcolsep} | p{\dimexpr 0.7\linewidth-2\tabcolsep}|}

==================   ================================
**Component**        **Recommended (2018)**
==================   ================================
Operating System      Linux, Mac, Windows (using Virtualbox)
RAM                   256 GB RAM
CPU                   Two CPUs with at least 12 cores. 64-bit.
Hard disk             12 x 10 TB SATA disks
Network               10/25 Gb/s Ethernet
==================   ================================


========================
DataNode and NodeManager
========================

A typical deployment of Hopsworks installs both the Hops DataNode and NodeManager on a set of commodity servers, running without RAID (replication is done in software) in a 12-24 hard-disk JBOD setup. Depending on your expected workloads, you can put as much RAM and CPU in the nodes as needed. Configurations can have up to (and probably more) than 1 TB RAM and 48 cores.

The recommended setup for these machines in production (on a cost-performance basis) is:

.. tabularcolumns:: {| p{\dimexpr 0.3\linewidth-2\tabcolsep} | p{\dimexpr 0.7\linewidth-2\tabcolsep}|}

==================   ================================
**Component**        **Recommended (2018)**
==================   ================================
Operating System      Linux, Mac, Windows (using Virtualbox)
RAM                   256 GB RAM
CPU                   Two CPUs with at least 12 cores. 64-bit.
Hard disk             12 x 10 TB SATA disks
Network               10/25 Gb/s Ethernet
==================   ================================
     
