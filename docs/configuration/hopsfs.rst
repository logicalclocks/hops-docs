.. _hopsFS_Configuration:

HopsFS Configuration
=====================

This section contains new/modified configuration parameters for HopsFS. All the configuration parameters are defined in ``hdfs-site.xml`` and ``core-site.xml`` files. 

Leader Election
---------------

Leader election service is used by HopsFS and Hops-YARN. The configuration parameters for Leader Election service are defined in ``core-site.xml`` file. 

* **dfs.leader.check.interval**:
  The length of the time period in milliseconds after which NameNodes run the leader election protocol. One of the active NameNodes is chosen as a leader to perform housekeeping operations. All NameNodes periodically update a counter in the database to mark that they are active. All NameNodes also periodically check for changes in the membership of the NameNodes. By default the time period is set to one second. Increasing the time interval leads to slow failure detection.
* **dfs.leader.missed.hb**:
  This property specifies when a NameNode is declared dead. By default a NameNode is declared dead if it misses two consecutive heartbeats. Higher values of this property would lead to slower failure detection. The minimum supported value is 2.
* **dfs.leader.tp.increment**:
    HopsFS uses an eventual leader election algorithm where the heartbeat time period (**dfs.leader.check.interval**) is automatically incremented if it detects that the NameNodes are falsely declared dead due to missed heartbeats caused by network/database/CPU overload. By default the heartbeat time period is incremented by 100 milliseconds, however it can be overridden using this parameter. 


.. _cache-parameters:

NameNode Cache 
--------------

The NameNode cache configuration parameters are defined in ``hdfs-site.xml`` file. The NameNode cache configuration parameters are:

* **dfs.resolvingcache.enabled**: (true/false)
  Enable/Disables the cache for the NameNode.

* **dfs.resolvingcache.type**: Each NameNode caches the inodes metadata in a local cache for quick path resolution. We support different implementations for the cache, i.e., INodeMemcache, PathMemcache, OptimalMemcache and InMemory.

    * **INodeMemcache**: stores individual inodes in Memcached. 
    * **PathMemcache**: is a course grain cache where entire file path (key) along with its associated inodes objects are stored in the Memcached.
    * **OptimalMemcache**: combines INodeMemcache and PathMemcache. 
    * **InMemory**: Same as INodeMemcache but instead of using Memcached it uses an inmemory **LRU ConcurrentLinkedHashMap**. We recommend **InMemory** cache as it yields higher throughput. 

For INodeMemcache/PathMemcache/OptimalMemcache following configurations parameters must be set.

* **dfs.resolvingcache.memcached.server.address**:
  Memcached server address.

* **dfs.resolvingcache.memcached.connectionpool.size**:
  Number of connections to the memcached server.

* **dfs.resolvingcache.memcached.key.expiry**:
  It determines when the memcached entries expire. The default value is 0, that is, the entries never expire. Whenever the NameNode encounters an entry that is no longer valid, it updates it.


The InMemory cache specific configurations are:

* **dfs.resolvingcache.inmemory.maxsize**:
  Max number of entries that could be stored in the cache before the LRU algorithm kicks in.


Distributed Transaction Hints 
-----------------------------

In HopsFS the metadata is partitioned using the inodes' id. HopsFS tries to to enlist the transactional filesystem operation on the database node that holds the metadata for the file/directory being manipulated by the operation. Distributed transaction hints configuration parameteres are defined in ``hdfs-site.xml`` file. 

* **dfs.ndb.setpartitionkey.enabled**: (true/false)
  Enable/Disable transaction partition key hint.
* **dfs.ndb.setrandompartitionkey.enabled**: (true/false)
  Enable/Disable random partition key hint when HopsFS fails to determine appropriate partition key for the transactional filesystem operation.


.. _quota-parameters:

Quota Management 
----------------

In order to boost the performance and increase the parallelism of metadata operations the quota updates are applied asynchronously i.e. disk and namespace usage statistics are asynchronously updated in the background. Using asynchronous quota system it is possible that some users over consume namespace/disk space before the background quota system throws an exception. Following parameters controls how aggressively the quota subsystem updates the quota statistics. Quota management configuration parameters are defined in ``hdfs-site.xml`` file. 

* **dfs.quota.enabled**:
  Enable/Disabled quota. By default quota is enabled.
* **dfs.namenode.quota.update.interval**:
  The quota update manager applies the outstanding quota updates after every dfs.namenode.quota.update.interval milliseconds.
* **dfs.namenode.quota.update.limit**:
  The maximum number of outstanding quota updates that are applied in each round.


Distributed Unique ID generator
-------------------------------

ClusterJ API does not support any means to auto generate primary keys. Unique key generation is left to the application. Each NameNode has an ID generation daemon. ID generator keeps pools of pre-allocated IDs. The ID generation daemon keeps track of IDs for inodes, blocks and quota entities. Distributed unique ID generator configuration parameters are defined in ``hdfs-site.xml``.

* **dfs.namenode.quota.update.id.batchsize**, **dfs.namenode.inodeid.batchsize**, **dfs.namenode.blockid.batchsize**:
  When the ID generator is about to run out of the IDs it pre-fetches a batch of new IDs. These parameters defines the prefetch batch size for Quota, inodes and blocks updates respectively. 
* **dfs.namenode.quota.update.updateThreshold**, **dfs.namenode.inodeid.updateThreshold**, **dfs.namenode.blockid.updateThreshold**:
  These parameters define when the ID generator should pre-fetch new batch of IDs. Values for these parameter are defined as percentages i.e. 0.5 means prefetch new batch of IDs if 50 percent of the IDs have been consumed by the NameNode.
* **dfs.namenode.id.updateThreshold**:
  It defines how often the IDs Monitor should check if the ID pools are running low on pre-allocated IDs.

Namespace and Block Pool ID
---------------------------

* **dfs.block.pool.id**, and **dfs.name.space.id**:
  Due to shared state among the NameNodes, HopsFS only supports single namespace and one block pool. The default namespace and block pool ids can be overridden using these parameters.


.. _client-conf-parameters:

Client Configurations
---------------------

All the client configuration parameters are defined in ``core-site.xml`` file. 

* **dfs.namenodes.rpc.addresses**:
  HopsFS support multiple active NameNodes. A client can send a RPC request to any of the active NameNodes. This parameter specifies a list of active NameNodes in the system. The list has following format [hdfs://ip:port, hdfs://ip:port, ...]. It is not necessary that this list contain all the active NameNodes in the system. Single valid reference to an active NameNode is sufficient. At the time of startup the client obtains an updated list of NameNodes from a NameNode mentioned in the list. If this list is empty then the client tries to connect to **fs.default.name**.

* **dfs.namenode.selector-policy**:
  The clients uniformly distribute the RPC calls among the all the NameNodes in the system based on the following policies. 
  - ROUND ROBIN
  - RANDOM
  - RANDOM_STICKY
  By default NameNode selection policy is set to RANDOM_STICKY

* **dfs.clinet.max.retires.on.failure**:
  The client retries the RPC call if the RPC fails due to the failure of the NameNode. This configuration parameter specifies how many times the client would retry the RPC before throwing an exception. This property is directly related to number of expected simultaneous failures of NameNodes. Set this value to 1 in case of low failure rates such as one dead NameNode at any given time. It is recommended that this property must be set to value >= 1.
* **dfs.client.max.random.wait.on.retry**:
  A RPC can fail because of many factors such as NameNode failure, network congestion etc. Changes in the membership of NameNodes can lead to contention on the remaining NameNodes. In order to avoid contention on the remaining NameNodes in the system the client would randomly wait between [0,MAX VALUE] ms before retrying the RPC. This property specifies MAX VALUE; by default it is set to 1000 ms.
* **dfs.client.refresh.namenode.list**:
  All clients periodically refresh their view of active NameNodes in the system. By default after every minute the client checks for changes in the membership of the NameNodes. Higher values can be chosen for scenarios where the membership does not change frequently.

.. _ndb-conf-parameters:

Data Access Layer (DAL)
-----------------------

Using DAL layer HopsFS's metadata can be stored in different databases. HopsFS provides a driver to store the metadata in MySQL Cluster Network Database (NDB). 

MySQL Cluster Network Database Driver Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Database specific parameter are stored in a ``.properties`` file. The configuration files contains following parameters. 

* **com.mysql.clusterj.connectstring**:
  Address of management server of MySQL NDB Cluster.
  
* **com.mysql.clusterj.database**:
  Name of the database schema that contains the metadata tables.
  
* **com.mysql.clusterj.connection.pool.size**:
  This is the number of connections that are created in the ClusterJ connection pool. If it is set to 1 then all the sessions share the same connection; all requests for a SessionFactory with the same connect string and database will share a single SessionFactory. A setting of 0 disables pooling; each request for a SessionFactory will receive its own unique SessionFactory.
  
* **com.mysql.clusterj.max.transactions**:
  Maximum number transactions that can be simultaneously executed using the clusterj client. The maximum support transactions are 1024.
  
* **io.hops.metadata.ndb.mysqlserver.host**
  Address of MySQL server. For higher performance we use MySQL Server to perform a aggregate queries on the file system metadata.
  
* **io.hops.metadata.ndb.mysqlserver.port**:
  If not specified then default value of 3306 will be used.
  
* **io.hops.metadata.ndb.mysqlserver.username**:
  A valid user name to access MySQL Server.
  
* **io.hops.metadata.ndb.mysqlserver.password**:
  MySQL Server user password
  
* **io.hops.metadata.ndb.mysqlserver.connection pool size**:
  Number of NDB connections used by the MySQL Server. The default is set to 10. 
  
* **Database Sessions Pool**:
  For performance reasons the data access layer maintains a pools of pre-allocated ClusterJ session objects. Following parameters are used to control the behavior the session pool.
  
  - **io.hops.session.pool.size**:
    Defines the size of the session pool. The pool should be at least as big as the number of active transactions in the system. Number of active transactions in the system can be calculated as ( **dfs.datanode.handler.count** + **dfs.namenode.handler.count** + **dfs.namenode.subtree-executor-limit**). 
  - **io.hops.session.reuse.count**:
    Session is used N times and then it is garbage collected. Note: Due to imporoved memory management in ClusterJ >= 7.4.7, N can be set to higher values i.e. Integer.MAX_VALUE for latest ClusterJ libraries. 

.. _loading_ndb_driver:

Loading a DAL Driver
~~~~~~~~~~~~~~~~~~~~

In order to load a DAL driver following configuration parameters are added to ``hdfs-site.xml`` file.

* **dfs.storage.driver.jarFile**:
  path of driver jar file if the driver's jar file is not included in the class path.

* **dfs.storage.driver.class**: 
  main class that initializes the driver.

* **dfs.storage.driver.configfile**:
  path to a file that contains configuration parameters for the driver jar file. The path is supplied to the **dfs.storage.driver.class** as an argument during initialization. See :ref:`hops ndb driver configuration parameters <ndb-conf-parameters>`.
  
  
  
HopsFS-EC Configuration
-----------------------

The erasure coding API is flexibly configurable and hence comes with some new configuration options that are shown here. All configuration options can be set by creating an ``erasure-coding-site.xml`` in the Hops configuration folder. Note that Hops comes with reasonable default values for all of these values. However, erasure coding needs to be enabled manually.


* **dfs.erasure_coding.enabled**: (true/false) Enable/Disable erasure coding.

* **dfs.erasure_coding.codecs.json**: List of available erasure coding codecs available. This value is a json field i.e.

.. code-block:: xml

	  <value>
		[ 
		  {
			"id" : "xor",
			"parity_dir" : "/raid",
			"stripe_length" : 10,
			"parity_length" : 1,
			"priority" : 100,
			"erasure_code" : "io.hops.erasure_coding.XORCode",
			"description" : "XOR code"
		  },
		  {
			"id" : "rs",
			"parity_dir" : "/raidrs",
			"stripe_length" : 10,
			"parity_length" : 4,
			"priority" : 300,
			"erasure_code" : "io.hops.erasure_coding.ReedSolomonCode",
			"description" : "ReedSolomonCode code"
		  },
		  {
			"id" : "src",
			"parity_dir" : "/raidsrc",
			"stripe_length" : 10,
			"parity_length" : 6,
			"parity_length_src" : 2,
			"erasure_code" : "io.hops.erasure_coding.SimpleRegeneratingCode",
			"priority" : 200,
			"description" : "SimpleRegeneratingCode code"
		  },
		]
	  </value>


* **dfs.erasure_coding.parity_folder**: The HDFS folder to store parity information in. Default value is /parity

* **dfs.erasure_coding.recheck_interval**: How frequently should the system schedule encoding or repairs and check their state. Default valude is 300000 ms.

* **dfs.erasure_coding.repair_delay**: How long should the system wait before scheduling a repair. Default is 1800000 ms.

* **dfs.erasure_coding.parity_repair_delay**: How long should the system wait before scheduling a parity repair. Default is 1800000 ms. 

* **dfs.erasure_coding.active_encoding_limit**: Maximum number of active encoding jobs. Default is 10. 

* **dfs.erasure_coding.active_repair_limit**: Maximum number of active repair jobs. Default is 10. 

* **dfs.erasure_coding.active_parity_repair_limit**: Maximum number of active parity repair jobs. Default is 10. 

* **dfs.erasure_coding.deletion_limit**: Delete operations to be handle during one round. Default is 100.

* **dfs.erasure_coding.encoding_manager**: Implementation of the EncodingManager to be used. Default is ``io.hops.erasure_coding.MapReduceEncodingManager``.

* **dfs.erasure_coding.block_rapair_manager**: Implementation of the repair manager to be used. Default is ``io.hops.erasure_coding.MapReduceBlockRepairManager``

  
  
