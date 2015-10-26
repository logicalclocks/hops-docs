************************************
Installation Guide
************************************

The Hops stack includes a number of services also requires a number of third-party distributed services:

* Java 1.7 (OpenJDK or Oracle JRE/JDK)
* NDB 7.4+ (MySQl Cluster)
* J2EE7 web application server (Glassfish by default)
* ElasticSearch 1.7+
  
Due to the complexity of installing and configuring all Hops' services, we recommend installing Hops using the automated installer Karamel/Chef (www.karamel.io). We do not provide documentation for installing and configuring all services, but for the curious, the Chef cookbooks that install our services are available at: https://github.com/hopshadoop.


Cloud Platforms (EC2, GCE, OpenStack)
---------------------------------------

#. Download and install Karamel (www.karamel.io).
#. Run Karamel.
#. Click on the "Load Cluster Definition" menu item in Karamel. You are now prompted to select a cluster definition YAML file. Go to the examples/stable directory, and select a cluster definition file for your target cloud platform.
      
**Amazon Web Services (EC2)**

   #. HopsWorks on a single node: *hopsworks-1node-aws-large.yml*
   #. HopsWorks on three nodes: *hopsworks-3node-aws-large.yml*

**Google Compute Engine (GCE)**

   #. HopsWorks on a single node: *hopsworks-1node-gce-large.yml*
   #. HopsWorks on three nodes: *hopsworks-3node-gce-large.yml*

**OpenStack**

Coming soon..


Linux On-Premises (bare-metal)
---------------------------------------

You will need to prepare for installation by

#. identifying a *master* host, from which you will run Karamel (it should have a display for Karamel's user interface);
#. identifying a set of *target* hosts, on which the Hops software and 3rd party services will be installed.

The *master* should be able to connect using SSH to all the *target* nodes on which the software will be installed.
To do this, you will first need to prepare the machines as follows:

#. Create an openssh public/private key pair on the *master* host for your user account. On Linux, you can use the ssh-keygen utility program to generate the keys, which will by default be stored in the $HOME/.ssh/id_rsa and $HOME/.ssh/id_rsa.pub files. If you decided to enter a password for the ssh keypair, you will need to enter it again in Karamel when you reach the ``ssh`` dialog, part of Karamel's ``Launch`` step.
#. Create a user account ``USER`` on the all the *target* machines with full sudo privileges and the same password on all *target* machines. 
   
**Preparing Password-less SSH**

#. Copy the $HOME/.ssh/id_rsa.pub file on the *master* to the /tmp folder of all the *target* hosts. A good way to do this is to use ``pscp`` utility along with a file (``hosts.txt``) containing the line-separated hostnames (or IP addresss) for all the *target* machines. You may need to install the pssh utility programs (``pssh``), first.

.. code-block:: bash   

   $sudo apt-get install pssh
   or
   $yum install pssh
 
   $cat hosts.txt
           128.112.152.122
           18.31.0.190
           128.232.103.201      

   $pscp -h hosts.txt -P PASSWORD -i USER ~/.ssh/id_rsa.pub /tmp
   $pssh -h hosts.txt -i USER -P PASSWORD mkdir -p /home/USER/.ssh
   $pssh -h hosts.txt -i USER -P PASSWORD cat /tmp/id_rsa.pub >> /home/USER/.ssh/authorized_keys
   
Update your Karamel cluster definition file to include the IP addresses of the *target* machines and the ``USER`` account. After you have clicked on the ``launch`` menu item, you will come to a ``Ssh`` dialog. On the ``ssh`` dialog, you need to open the advanced section. Here, you will need to enter the password for the ``USER`` account on the *target* machines (``sudo password`` text input box). 
If you decided to enter a password for the ssh keypair, you will also need to enter it again here in the ``keypair password`` text input box.


**Centos/Redhat Notes**

Redhat is not yet supported by Karamel, but you can install Hops using Chef-solo by logging into each machine separately. The chef cookbooks are written to work for both Ubuntu and Redhat platforms.


Vagrant
-------------

You can install HopsWorks and Hops with Vagrant. You will need to have the following software packages installed:

* chef-dk, version 0.5+
* git
* vagrant
* virtualbox

You can now run vagrant, using:

.. code-block:: bash     

    $ git clone https://github.com/hopshadoop/hopsworks-chef.git
    $ cd hopsworks-chef
    $ berks vendor cookbooks
    $ vagrant up

You can then access Hopsworks from your browser at http://127.0.0.1:8080/hopsworks. The default credentials are:

* username: admin@kth.se
* password: admin

The Glassfish web application server is also available from your browser at http://127.0.0.1:8080/hopsworks. The default credentials are:

* username: adminuser
* password: adminpw


Windows
-------------

You can also install HopsWorks on vagrant and Windows. You will need to follow the vagrant instructions as above (installing the same software packages) aswell as installing:

* Powershell

After cloning the github repo, from the powershell, you can run:

.. code-block:: bash     

    $ cd hopsworks-chef
    $ berks vendor cookbooks
    $ vagrant up
  
Mac
-------------
You can follow the baremetal instructions to install for Apple Mac.



Configuration
-----------------

This section discusses how to configure the services in Karamel before launching them.

Glassfish Configuration
=============================



ElasticSearch Configuration
=============================


MySQL Cluster (NDB) Configuration
=======================================

HopsFS Configuration
========================

This section contains new/modified configurations parameters for HopsFS. All the configuration parameters are defined in hdfs-site.xml file. 


Leader Election
++++++++++++++++

* **dfs.leader.check.interval**
  The length of the time period in milliseconds after which NameNodes run the leader election protocol. One of the active NameNodes is chosen as a leader to perform housekeeping operations. All NameNodes periodically update a counter in the database to mark that they are active. All NameNodes also periodically check for changes in the membership of the NameNodes. By default the time period is set to one second. Increasing the time interval leads to slow failure detection.
* **dfs.leader.missed.hb**
  This property specifies when a NameNode is declared dead. By default a NameNode is declared dead if it misses two consecutive heartbeats. Higher values of this property would lead to slower failure detection. The minimum supported value is 2.
* **dfs.leader.tp.increment**
    HopsFS uses an eventual leader election algorithm where the heartbeat time period (**dfs.leader.check.interval**) is automatically incremented if it detects that the NameNodes are falsely declared dead due to missed heartbeats caused by network/database/CPU overload. By default the heartbeat time period is incremented by 100 milliseconds, however it can be overridden using this parameter. 


NameNode Cache 
++++++++++++++++
NameNode cache configuration parameters are 

* **dfs.resolvingcache.enabled** (true/false)
  Enable/Disables the cache for the NameNode.

* **dfs.resolvingcache.type**
Each NameNode caches the inodes metadata in a local cache for quick path resolution. We support different implementations for the cache i.e. INodeMemcache, PathMemcache, OptimalMemcache and InMemory.

1. **INodeMemcache** stores individual inodes in Memcached. 
2. **PathMemcache** is a course grain cache where entire file path (key) along with its associated inodes objects are stored in the Memcached.
3. **OptimalMemcache**  combines INodeMemcache and PathMemcache. 
4. **InMemory** Same as INodeMemcache but instead of using Memcached it uses a LRU ConcurrentLinkedHashMap. We recommend **InMemory** cache as it yields higher throughput. 


For INodeMemcache/PathMemcache/OptimalMemcache following configurations parameters must be set.
* **dfs.resolvingcache.memcached.server.address**
  Memcached server address.
* **dfs.resolvingcache.memcached.connectionpool.size**
  Number of connections to the memcached server.
* **dfs.resolvingcache.memcached.key.expiry**
  It determines when the memcached entries expire. The default value is 0, that is, the entries never expire. Whenever the NameNode encounters an entry that is no longer valid, it updates it.


InMemory cache specific configurations are

* **dfs.resolvingcache.inmemory.maxsize**
Max number of entries that could be stored in the cache before the LRU algorithm kicks in.


Distributed Transaction Hints 
+++++++++++++++++++++++++++++
In HopsFS the metadata is partitioned using the inodes' id. HopsFS tries to to enlist the transactional filesystem operation on the database node that holds the metadata for the file/directory being manipulated by the operation. 

* **dfs.ndb.setpartitionkey.enabled** (true/false)
  Enable/Disable transaction partition key hint.
* **dfs.ndb.setrandompartitionkey.enabled** (true/false)
  Enable/Disable random partition key hint when HopsFS fails to determine appropriate partition key for the transactional filesystem operation.


Quota Management 
++++++++++++++++
In order to boost the performance and increase the parallelism of metadata operations the quota updates are applied asynchronously i.e. disk and namespace usage statistics are asynchronously updated in the background. Using asynchronous quota system it is possible that some users over consume namespace/disk space before the background quota system throws an exception. Following parameters controls how aggressively the quota subsystem updates the quota statistics. 

* **dfs.quota.enabled**
  Enable/Disabled quota. By default quota is enabled.
* **dfs.namenode.quota.update.interval**
   The quota update manager applies the outstanding quota updates after every dfs.namenode.quota.update.interval milliseconds.
* **dfs.namenode.quota.update.limit**
  The maximum number of outstanding quota updates that are applied in each round.


Distributed unique ID generator
++++++++++++++++++++++++++++++++
ClusterJ API does not support any means to auto generate primary keys. Unique key generation is left to the application. Each NameNode has an ID generation daemon. ID generator keeps pools of pre-allocated IDs. The ID generation daemon keeps track of IDs for inodes, blocks and quota entities.

* **dfs.namenode.quota.update.id.batchsize**, **dfs.namenode.inodeid.batchsize**, **dfs.namenode.blockid.batchsize**
  When the ID generator is about to run out of the IDs it pre-fetches a batch of new IDs. These parameters defines the prefetch batch size for Quota, inodes and blocks updates respectively. 
*  **dfs.namenode.quota.update.updateThreshold**, **dfs.namenode.inodeid.updateThreshold**, **dfs.namenode.blockid.updateThreshold**
  These parameters define when the ID generator should pre-fetch new batch of IDs. Values for these parameter are defined as percentages i.e. 0.5 means prefetch new batch of IDs if 50% of the IDs have been consumed by the NameNode.
* **dfs.namenode.id.updateThreshold**
  It defines how often the IDs Monitor should check if the ID pools are running low on pre-allocated IDs.

Namespace and Block Pool ID
++++++++++++++++++++++++++++

* **dfs.block.pool.id**, and **dfs.name.space.id**
  Due to shared state among the NameNodes, HopsFS only supports single namespace and one block pool. The default namespace and block pool ids can be overridden using these parameters.


.. Transaction Statistics 
.. ----------------------

.. * **dfs.transaction.stats.enabled**
..  Each NameNode collect statistics about currently running transactions. The statistics will be written in a comma separated file format, that could be parsed afterwards to get an aggregated view over all or specific transactions. By default transaction stats is disabled.

.. * **dfs.transaction.stats.detailed.enabled**
..  If enabled, The NameNode will write a more detailed and human readable version of the statistics. By default detailed transaction stats is disabled.

.. .. code-block:: none

..  Transaction: LEADER_ELECTION
..  ----------------------------------------
..  VariableContext
..    HdfsLeParams[PK] H=4 M=1
..  N=0 M=1 R=0
..  Hits=4(4) Misses=1(1)
..  Detailed Misses: PK 1(1)
..  ----------------------------------------
..  ----------------------------------------
..  HdfsLESnapshot
..    All[FT] H=0 M=1
..    ById[PK] H=1 M=0
..  N=1 M=0 R=0
..  Hits=1(0) Misses=1(0)
..  Detailed Misses: FT 1(0)
..  ----------------------------------------
..  Tx. N=1 M=1 R=0
..  Tx. Hits=5(4) Misses=2(1)
..  Tx. Detailed Misses: PK 1(1) FT 1(0)


.. * **dfs.transaction.stats.dir**
..  The directory where the stats are going to be written. Default directory is /tmp/hopsstats.
.. * **dfs.transaction.stats.writerround**
..  How frequent the NameNode will write collected statistics to disk. Time is in seconds. Default is 120 seconds.


Client Configurations
+++++++++++++++++++++
* **dfs.namenodes.rpc.addresses**
  HopsFS support multiple active NameNodes. A client can send a RPC request to any of the active NameNodes. This parameter specifies a list of active NameNodes in the system. The list has following format [hdfs://ip:port, hdfs://ip:port, ...]. It is not necessary that this list contain all the active NameNodes in the system. Single valid reference to an active NameNode is sufficient. At the time of startup the client obtains an updated list of NameNodes from a NameNode mentioned in the list. If this list is empty then the client will connect to ’fs.default.name’.

* **dfs.namenode.selector-policy**
  The clients uniformly distributes the RPC calls among the all the NameNodes in the system based on the following policies. 
  - ROUND ROBIN
  - RANDOM
  - RANDOM_STICKY
  By default NameNode selection policy is set to RANDOM_STICKY

* **dfs.clinet.max.retires.on.failure**
  The client retries the RPC call if the RPC fails due to the failure of the NameNode. This configuration parameter specifies how many times the client would retry the RPC before throwing an exception. This property is directly related to number of expected simultaneous failures of NameNodes. Set this value to 1 in case of low failure rates such as one dead NameNode at any given time. It is recommended that this property must be set to value >= 1.
* **dfs.client.max.random.wait.on.retry**
  A RPC can fail because of many factors such as NameNode failure, network congestion etc. Changes in the membership of NameNodes can lead to contention on the remaining NameNodes. In order to avoid contention on the remaining NameNodes in the system the client would randomly wait between [0,MAX VALUE] ms before retrying the RPC. This property specifies MAX VALUE; by default it is set to 1000 ms.
* **dfs.client.refresh.namenode.list**
  All clients periodically refresh their view of active NameNodes in the system. By default after every minute the client checks for changes in the membership of the NameNodes. Higher values can be chosen for scenarios where the membership does not change frequently.

Data Access Layer (DAL)
+++++++++++++++++++++++

MySQL Cluster Driver Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Using DAL layer HopsFS's metadata can be stored in different databases. HopsFS provides a driver to store the metadata in MySQL Cluster Database. Database specific parameter are stored in a **.properties** file. 

* **com.mysql.clusterj.connectstring**
  Address of management server of MySQL NDB Cluster.
* **com.mysql.clusterj.database**
  Name of the database that contains the metadata tables.
* **com.mysql.clusterj.connection.pool.size**
  This is the number of connections that are created in the ClusterJ connection pool. If it is set to 1 then all the sessions share the same connection; all requests for a SessionFactory with the same connect string and database will share a single SessionFactory. A setting of 0 disables pooling; each request for a SessionFactory will receive its own unique SessionFactory. We set the default value of this parameter to 3.
* **com.mysql.clusterj.max.transactions**
  Maximum number transactions that can be simultaneously executed using the clusterj client. The maximum support transactions are 1024.
* **io.hops.metadata.ndb.mysqlserver.host**
  Address of MySQL server. For higher performance we use MySQL Server to perform a aggregate queries on the file system metadata.
* **io.hops.metadata.ndb.mysqlserver.port**
  If not specified then default value of 3306 will be used.
* **io.hops.metadata.ndb.mysqlserver.username**
  A valid user name to access MySQL Server.
* **io.hops.metadata.ndb.mysqlserver.password**
  MySQL Server user password
* **io.hops.metadata.ndb.mysqlserver.connection pool size**
  Number of NDB connections used by the MySQL Server. The default is set to 10. 
* *Session Pool* 
  For performance reasons the data access layer maintains a pools of pre-allocated ClusterJ session objects. Following parameters are used to control the behavior the session pool.
  - **io.hops.session.pool.size**
    Defines the size of the session pool. The pool should be at least as big as the number of active transactions in the system. Number of active transactions in the system can be calculated as (num rpc handler threads + sub tree ops threads pool size). 
  - **io.hops.session.reuse.count**
     Session is used N times and then it is garbage collected.

Loading DAL Driver
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to load a DAL driver following configuration parameters are added to hdfs-site.xml

* **dfs.storage.driver.jarFile** path of driver jar file.

* **dfs.storage.driver.class** main class that initializes the driver.

* **dfs.storage.driver.configfile** path to a file that contains configuration parameters for the driver jar file. The path is supplied to the **dfs.storage.driver.class** as an argument during initialization. 




HopsYARN Configuration
=========================

