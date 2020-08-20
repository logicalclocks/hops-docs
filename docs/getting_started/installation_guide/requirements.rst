System Requirements
===========================

The recommended machine specifications given below are valid for either virtual machines or on-premises servers.

==========================
Hardware Requirements
==========================

CPU
---------------

Hopsworks contains many services and all run on x86 CPUs. It is recommended to have at least 8 CPUs for a single-server installation.


GPU
---------------

Hopsworks supports both Nvidia Cuda and AMD ROCm GPUs (through HopsYARN):

* ROCm 2.6

* Cuda 10.x+


==========================
Operating System Requirements
==========================

Hopsworks runs on the Linux operating system, and has been tested on the following Linux distributions:

* Ubuntu 18.04
* RedHat 7.6+
* Centos 7.6+

Hopsworks is not tested on other Linux distributions.


==========================
Database Requirements
==========================

Hopsworks and Hops require a MySQL compatible database.  MySQL Cluster (NDB) is the reccomended database. Hopsworks 1.0 requires at least the following version:

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


=================
Recommended Setup
=================

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
