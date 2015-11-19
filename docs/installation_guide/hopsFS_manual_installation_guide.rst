.. _hops-manual-installation:

**************************
HopsFS Manual Installation
**************************


Purpose and Overview
--------------------

All applications running on HDFS can easily migrate to HopsFS as HopsFS supports same client facing APIs as HDFS. Setting up HopsFS is similar to HDFS except HopsFS allows multiple NameNodes that store the metadata in an external database. 

HopsFS can be installed using `Karamel`_, an orchestration engine for Chef Solo, that enables the deployment of arbitrarily large distributed systems on both virtualized platforms (AWS, Vagrant) and bare-metal hosts (see :ref:`Hops Auto Installer <hops-installer>` for more details). This document serves as starting point for manually installing and configuring HopsFS. 


Required Softwares
------------------
Ensure that Java 1.6.X or higer, and Protocol Buffer 2.5 are installed.


Download and Compile Sources
----------------------------
HopsFS consists of two modules i.e. HopsFS source code and Database Driver consisting of Data Access Layer Interface, Data Access Layer Implementation projects. 

Building Driver
~~~~~~~~~~~~~~~

Download the source code for Data Access Layer Interface:: 

   $ git clone https://github.com/hopshadoop/hops-metadata-dal
   $ cd hops-metadata-dal
   $ mvn install

Download the source code for Data Access Layer Implementation:: 
     
   $ git clone https://github.com/hopshadoop/hops-metadata-dal-impl-ndb
   $ cd hops-metadata-dal-impl
   $ mvn install

This generates a driver jar file ``./target/hops-metadata-dal-impl-ndb-1.0-SNAPSHOT.jar`` which is used by the HopsFS to communicate with the database. 

Building HopsFS
~~~~~~~~~~~~~~~

Download the source code for HopsFS:: 

   $ git clone https://github.com/hopshadoop/hops
   $ cd hops
   $ mvn clean install generate-sources  package -Pdist,ndb,native -Dtar
   
This generates a hadoop distribution folder ``./hadoop-dist`` that uses HopsFS instead of HDFS. Note: this disturbution also contains our distribution of Highly sacalable and higly available YARN. 



Installing Distributed Database
-------------------------------

HopsFS uses Mysql Cluster Network Database (NDB) to store the filesystem metadata. NDB can be install using `Karamel`_. Karamel comes with many sample installation recipies for NDB that can be found in the ``examples`` folder of the Karamel installation. 

Instructions for manually installing NDB is out of the scope of this documentation. We refer you to official `NDB Installation`_ manual for installing NDB. 



.. _Karamel: http://www.karamel.io/
.. _NDB Installation: https://dev.mysql.com/doc/refman/5.1/en/mysql-cluster-installation.html
