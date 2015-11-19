.. _hops-manual-installation:

********************************
HopsFS Manual Installation Guide
********************************


Purpose and Overview
--------------------

All applications running on HDFS can easily migrate to HopsFS as HopsFS supports same client facing APIs as HDFS. Setting up HopsFS is similar to HDFS except HopsFS allows multiple NameNodes that store the metadata in an external database. 

HopsFS can be installed using `Karamel`_, an orchestration engine for Chef Solo, that enables the deployment of arbitrarily large distributed systems on both virtualized platforms (AWS, Vagrant) and bare-metal hosts (see :ref:`Hops Auto Installer <hops-installer>` for more details). This document serves as starting point for manually installing and configuring HopsFS. 


Required Softwares
------------------
Ensure that Java 1.6.X or higher, and Protocol Buffer 2.5 are installed.


Download and Compile Sources
----------------------------
HopsFS consists of two modules i.e. HopsFS source code and Database Driver consisting of Data Access Layer Interface, Data Access Layer Implementation projects. 

Building Driver
~~~~~~~~~~~~~~~

Download the source code for Data Access Layer Interface:: 

   > git clone https://github.com/hopshadoop/hops-metadata-dal
   > cd hops-metadata-dal
   > mvn install

Download the source code for Data Access Layer Implementation:: 
     
   > git clone https://github.com/hopshadoop/hops-metadata-dal-impl-ndb
   > cd hops-metadata-dal-impl
   > mvn install

This generates a driver jar file ``./target/hops-metadata-dal-impl-ndb-1.0-SNAPSHOT.jar`` which is used by the HopsFS to communicate with the database. 

Building HopsFS
~~~~~~~~~~~~~~~

Download the source code for HopsFS:: 

   > git clone https://github.com/hopshadoop/hops
   > cd hops
   > mvn clean install generate-sources  package -Pdist,ndb,native -Dtar
   
This generates a hadoop distribution folder ``./hadoop-dist`` that uses HopsFS instead of HDFS. Note: this distribution also contains our distribution of Highly scalable and highly available YARN. 



Installing Distributed Database
-------------------------------

HopsFS uses Mysql Cluster Network Database (NDB) to store the filesystem metadata. NDB can be install using `Karamel`_. Karamel comes with many sample installation recopies for NDB that can be found in the ``examples`` folder of the Karamel installation. 

Instructions for manually installing NDB is out of the scope of this documentation. We refer you to official `NDB Installation Manual`_ for installing NDB. 


Installation
------------

Installation involves copying the ``hadoop-dist`` folder on all the machines in the cluster. Ensure that all the machines have Java 1.6 or higher installed. 



Configuring HopsFS in Non-Secure Mode
-------------------------------------

HopsFS consist of three types of nodes i.e. NameNodes, DataNodes, and Clients. Like HDFS all the configurations parameters are defined in ``core-site.xml`` and ``hdfs-site.xml`` files. 

Currently HopsFS only supports non-secure mode of operations. In the following sections we will discuss how to configure NameNodes, DataNodea and Clients. As HopsFS has similar code base as HDFS, most of the `HDFS configuration parameters`_ are supported in HopsFS. In this section we highlight only the new configuration parameters and the parameters that are not supported due to different metadata management scheme. 

Configuring NameNodes
~~~~~~~~~~~~~~~~~~~~~

HopsFS supports multiple NameNodes. A NameNode is configured as if it is the only NameNode in the system. Using the database a NameNode discovers all the existing NameNodes in the system. One of the NameNodes is declared the leader for housekeeping and maintenance operations.  

All the NameNodes in HopsFS are active. Secondary NameNode and Checkpoint Node configurations are not supported. See :ref:`section <Unsupported_Features>` for detail list of configuration parameters and features that are no longer supported in HopsFS. 

For each NameNode define ``fs.defaultFS`` configuration parameter in the core-site.xml file. In order to load NDB driver set the ``dfs.storage.driver.*`` parameters in the ``hdfs-site.xml`` file. These parameter are defined in detail :ref:`here <loading_ndb_driver>`. 

A detailed description of all the new configuration parameters for leader election, NameNode caches, distributed transaction handling, quota management, id generation and client configurations are defined :ref:`here<hopsFS_Configuration>`.


The NameNodes are started/stopped using the following commands::

    > $HADOOP_HOME/sbin/hadoop-daemon.sh --script hdfs start namenode
    
    > $HADOOP_HOME/sbin/hadoop-daemon.sh --script hdfs stop namenode

See :ref:`section <format_cluster>` for instructions for formating the filesystem. 

Configuring DataNodes
~~~~~~~~~~~~~~~~~~~~~

HopsFS DataNodes configuration is identical to HDFS DataNodes. In HopsFS a DataNode connects to all the NameNodes. Make sure that the ``fs.defaultFS`` parameter points to valid NameNode in the system. The DataNode will connect to the NameNode and obtain a list of all the active NameNodes in the system, and then connects/registers with all the NameNodes in the system. 

The datanodes are started/stopped using the following commands::
   
   > $HADOOP_HOME/sbin/hadoop-deamon.sh --script hdfs start datanode 
   
   > $HADOOP_HOME/sbin/hadoop-deamon.sh --script hdfs stop datanode


Configuring Clients
~~~~~~~~~~~~~~~~~~~

In HDFS the client connects to the ``fs.defaultFS`` NameNode. In HopsFS the client obtains the list of active NameNodes from the NameNode defined using ``fs.defaultFS`` parameter. The client then uniformly distributes the subsequent filesystem operations among the list of NameNodes. 

In ``core-site.xml`` we have introduced a new parameter ``dfs.namenodes.rpc.addresses`` that holds the rpc address of all the NameNodes in the system. If the NameNode pointed by ``fs.defaultFS`` is dead then the client tries to connect to a NameNode defined by the ``dfs.namenodes.rpc.addresses``. As long as the NameNode addresses defined by the two parameters contain at least one valid address the client is able to communicate with the HopsFS. A detailed description of all the new client configuration parameters are :ref:`here<client-conf-parameters>`.

HopsFS clients are invoked in an identical manner as HDFS i.e.::

   > $HADOOP_HOME/bin/hdfs {parameters}
   
   > $HADOOP_HOME/bin/hadoop dfs {parameters}





.. _Karamel: http://www.karamel.io/
.. _NDB Installation Manual: https://dev.mysql.com/doc/refman/5.1/en/mysql-cluster-installation.html
.. _HDFS configuration parameters: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml
