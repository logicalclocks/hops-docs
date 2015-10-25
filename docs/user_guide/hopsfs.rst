******************
HopsFS User Guide
******************


Hops-FS is a new implementation of the the Hadoop Filesystem (HDFS) based on `Apache Hadoop`_ 2.0.4-alpha, that supports multiple stateless NameNodes, where the metadata is stored in an in-memory distributed database (MySQL Cluster). Hops-FS enables more scalable clusters than Apache HDFS (up to ten times larger clusters), and enables NameNode metadata to be both customized and analyzed, because it can now be easily accessed via a SQL API.

.. figure:: ../imgs/hopsfs-arch.png
   :alt: HopsFS vs Apache HDFS Architecture

We have replaced HDFS 2.x's Primary-Secondary Replication model with shared atomic transactional memory. This means that we no longer use the parameters in HDFS that are based on the (eventually consistent) replication of edit log entries from the Primary NameNode to the Secondary NameNode using a set of quorum-based replication servers. Simlarly, HopsFS, does not uses ZooKeeper and implements leader election and membership service using the transactional shared memory.
Hops-FS is a drop-in replacement for HDFS and it supports most of the `configuration`_ parameters defined for Apache HDFS. Following is the list of HDFS features and configurations that are not applicable in HopsFS

Unsupported HDFS Features
===============
* **Secondary NameNode**
	The secondary NameNode is no longer supported. Hops-FS supports multiple NameNodes and all the NameNodes are active. Thus **hdfs haadmin *** command; and **dfs.namenode.secondary.*** and **dfs.ha.*** configuration parameters are not supported in HopsFS.
* **Checkpoint Node**
    HopsFS does not require checkpoint nodes as all the metadata is stored in highly available external database. Thus **dfs.namenode.checkpoint.*** configuration parameters are not supported in HopsFS.
* **EditLog**
	The write ahead log (EditLog) is not needed as all the metadata mutations are stored in the highly available transactional memory. Thus **dfs.namenode.num.extra.edits.*** and **dfs.namenode.edits.*** configuration parameters are not supported in HopsFS.
* **FSImage** configuration parameters are not supported in HopsFS.
	We don’t need to store checkpoints of the metadata (FSImage) as NameNodes in Hops-FS are stateless and metadata is stored in the external metadata store. Thus **hdfs dfsadmin -saveNamespace|metaSave|restoreFailedStorage|rollEdits|fetchImage** commands; and **dfs.namenode.name.dir.*** and **dfs.image.*** configuration parameters are not supported in HopsFS.
* **Quorum Based Journaling**
	Replaced by the external metadata store. Thus **dfs.journalnode.*** configuration parameters are not supported in HopsFS.
* **NameNode Federation and ViewFS**
	To support very large namespace the namespace is statically partitioned among multiple namenodes. HDFS Federation and ViewFS, a HDFS Federation management tool, are no longer supported as the namespace in HopsFS scales to billions of files and directories. Thus **dfs.nameservices.*** configuration parameters are not supported in HopsFS.
* **ZooKeeper**
	ZooKeeper is no long required as the coordination and membership `service`_ is implemented using the transactional shared memory. 
	


Temporary Unsupported Features
--------------------
Following commands are not currently supported as HopsFS is under heavy development. These commands will be activated in future releases. 

* **hdfs dfsadmin rollingUpgrade ***
* **hdfs dfadmin -allowSnapshot**
* **hdfs dfadmin -disallowSnapshot**


HopsFs Configurations
=====================
This section contains new/modified configurations parameters for HopsFS. All the configuration parameters are defined in hdfs-site.xml file. 


Leader Election
---------------

* **dfs.leader.check.interval**
	The length of the period in milliseconds on which NameNodes run the leader election protocol. One of the active NameNodes is chosen as a leader to perform housekeeping operations. All NameNodes periodically update a counter in the database to mark that they are active. All NameNodes also periodically check for changes in the membership of the NameNodes. By default the period is to one second. Increasing the time interval would lead to slow failure detection.
* **dfs.leader.missed.hb**
	This property specifies when a NameNode is declared dead. By default a NameNode is declared dead if it misses a HeartBeat. Higher values of this property would lead to slower failure detection.
* **dfs.leader.tp.increment**
    HopsFS uses an eventual leader election algorithm where the heartbeat time period (**dfs.leader.check.interval**) is automatically incremented if it detects that the NameNodes are falsely declared dead due to missed heartbeats caused by network/database/CPU overload. By default the heartbeat time period is incremented by 100 milliseconds, however it can be overridden using this parameter. 


NameNode Cache 
--------------
NameNode cache configuration parameters are 

* **dfs.resolvingcache.enabled**
	Enables/Disables the cache for the NameNode.

* **dfs.resolvingcache.type**
Each NameNode caches the inodes metadata in a local cache for quick file path resolution. We support different implementations for the cache; INodeMemcache, PathMemcache, OptimalMemcache and InMemory.

1. **INodeMemcache** stores individual inodes in Memcached. 
2. **PathMemcache** is a course grain cache where entire file path (key) along with its associated inodes objects are stored in the Memcached
3. **OptimalMemcache** 	is combination of INodeMemcache and PathMemcache. 
4. **InMemory** Same as INodeMemcache, but instead of using Memcached, it uses a LRU ConcurrentLinkedHashMap. We recommend **InMemory** cache as it gives higher throughput. 


For INodeMemcache/PathMemcache/OptimalMemcache following configurations parameters must be set.
* **dfs.resolvingcache.memcached.server.address**
	Memcached server address.
* **dfs.resolvingcache.memcached.connectionpool.size**
	Number of connections to the memcached server.
* **dfs.resolvingcache.memcached.key.expiry**
	It determines when the memcached entries expire. The default value is 0, that is, the entries never expire. Whenever the NameNode encounters an entry that is no longer valid, it updates it.


InMemory cache specific configurations are

* **dfs.resolvingcache.inmemory.maxsize**
Max number of entries that could be in the cache before the LRU algorithm kicks in.


Distributed Transaction Hints 
-----------------------------
In HopsFS the metadata is partitioned using the inodes' id. HopsFS tries to to enlist the transactional filesystem operation on the database node that holds the metadata for the file/directory being manipulated by the operation. 

* **dfs.ndb.setpartitionkey.enabled** (true/false)
	Enable/Disable transaction partition key hint.
* **dfs.ndb.setrandompartitionkey.enabled** (true/false)
	Enable/Disable random partition key hint when HopsFS fails to determine appropriate partition key for the transactional filesystem operation.


Quota Management 
----------------
In order to boost the performance and increase the parallelism of metadata operations the quota updates are applied asynchronously i.e. disk and namespace usage statistics are asynchronously updated in the background. Using asynchronous quota system it is possible that some users over consume disk space before the background quota system throws an exception. Following parameters controls how aggressively the quota subsystem updates the quota statistics. 

* **dfs.quota.enabled**
	En/Disabled quota. By default quota is enabled.
* **dfs.namenode.quota.update.interval**
	 The quota update manager applies the outstanding quota updates after every dfs.namenode.quota.update.interval milliseconds.
* **dfs.namenode.quota.update.limit**
	The maximum number of outstanding quota updates that are applied in each round.


Distributed unique ID generator
-------------------------------
ClusterJ API does not support any means to auto generate primary keys. Unique key generation is left to the application. Each NameNode has an ID generation daemon. ID generator keeps pools of pre-allocated IDs. The ID generation daemon keeps track of IDs for inodes, blocks and quota entities.

* **dfs.namenode.quota.update.id.batchsize**, **dfs.namenode.inodeid.batchsize**, **dfs.namenode.blockid.batchsize**
	When the ID generator is about to run out of the IDs it pre-fetches a batch of new IDs. These parameters defines the prefetch batch size for Quota, inodes and blocks updates respectively. 
*  **dfs.namenode.quota.update.updateThreshold**, **dfs.namenode.inodeid.updateThreshold**, **dfs.namenode.blockid.updateThreshold**
	These parameters define when the ID generator should pre-fetch new batch of IDs. Values for these parameter are defined as percentages i.e. 0.5 means prefetch new batch of IDs if 50% of the IDs have been consumed by the NameNode.
* **dfs.namenode.id.updateThreshold**
	It defines how often the IDs Monitor should check if the ID pools are running low on pre-allocated IDs.



Namespace and Block Pool ID
---------------------------

* **dfs.block.pool.id**, and **dfs.name.space.id**
	Due to shared state among the NameNodes, Hops-FS only supports single namespace and one block pool. The default namespace and block pool ids can be overridden using these parameters.



.. Transaction Statistics 
.. ----------------------

.. * **dfs.transaction.stats.enabled**
..	Each NameNode collect statistics about currently running transactions. The statistics willbe written in a comma separated file format, that could be parsed afterwards to get an aggregated view over all or specific transactions. By default transaction stats is disabled.

.. * **dfs.transaction.stats.detailed.enabled**
..	If enabled, The NameNode will write a more detailed and human readable version of the statistics. By default detailed transaction stats is disabled.

.. .. code-block:: none

.. 	Transaction: LEADER_ELECTION
.. 	----------------------------------------
.. 	VariableContext
.. 		HdfsLeParams[PK] H=4 M=1
.. 	N=0 M=1 R=0
.. 	Hits=4(4) Misses=1(1)
.. 	Detailed Misses: PK 1(1)
.. 	----------------------------------------
.. 	----------------------------------------
.. 	HdfsLESnapshot
.. 		All[FT] H=0 M=1
.. 		ById[PK] H=1 M=0
.. 	N=1 M=0 R=0
.. 	Hits=1(0) Misses=1(0)
.. 	Detailed Misses: FT 1(0)
.. 	----------------------------------------
.. 	Tx. N=1 M=1 R=0
.. 	Tx. Hits=5(4) Misses=2(1)
.. 	Tx. Detailed Misses: PK 1(1) FT 1(0)


.. * **dfs.transaction.stats.dir**
.. 	The directory where the stats are going to be written. Default directory is /tmp/hopsstats.
.. * **dfs.transaction.stats.writerround**
.. 	How frequent the NameNode will write collected statistics to disk. Time is in seconds. Default is 120 seconds.


Client Configurations
----------------------

* **dfs.namenodes.rpc.addresses**
	HopsFS support multiple active NameNodes. A client can send a RPC request to any of the active NameNodes. This parameter specifies a list of active NameNodes in the system. The list has following format [hdfs://ip:port, hdfs://ip:port, ...]. It is not necessary that this list contain all the active NameNodes in the system. Single valid reference to an active NameNode is sufficient. At the time of startup the client obtains an updated list of NameNodes from a NameNode mentioned in the list. If this list is empty then the client will connect to ’fs.default.name’.

* **dfs.namenode.selector-policy**
	The clients uniformly distributes the RPC calls among the all the NameNodes in the system based on the following policies. 
	- ROUND ROBIN
	- RANDOM
	- RANDOM_STICKY
	By default NameNode selection policy is set to RANDOM_STICKY

* **dfs.clinet.max.retires.on.failure**
	The client will retry the RPC call if the RPC fails due to the failure of the NameNode. This configuration parameter specifies how many times the client would retry the RPC before throwing an exception. This property is directly related to number of expected simultaneous failures of NameNodes. Set this value to 1 in case of low failure rates such as one dead NameNode at any given time. It is recommended that this property must be set to value >= 1.
* **dfs.client.max.random.wait.on.retry**
	A RPC can fail because of many factors such as NameNode failure, network congestion etc. Changes in the membership of NameNodes can lead to contention on the remaining NameNodes. In order to avoid contention on the remaining NameNodes in the system the client would randomly wait between [0,MAX VALUE] ms before retrying the RPC. This property specifies MAX VALUE; by default it is set to 1000 ms.
* **dfs.client.refresh.namenode.list**
	All clients periodically refresh their view of active NameNodes in the system. By default after every minute the client checks for changes in the membership of the NameNodes. Higher values can be chosen for scenarios where the membership does not change frequently.


Data Access Layer (DAL) Configuration Parameters
================================================

MySQL Cluster Driver Configuration
----------------------------------
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
------------------

In order to load a DAL driver following configuration parameters are added to hdfs-site.xml

* **dfs.storage.driver.jarFile** path of driver jar file.

* **dfs.storage.driver.class** main class that initializes the driver.

* **dfs.storage.driver.configfile** path to a file that contains configuration parameters for the jar file. The path is supplied to the **dfs.storage.driver.class** as an argument during initialization. 


Erasure Coding
==============
Hops-FS provides erasure coding functionality in order to decrease storage costs without the loss of high-availability. Hops offers a powerful, on a per file basis configurable, erasure coding API. Codes can be freely configured and different configurations can be applied to different files. Given that Hops monitors your erasure-coded files directly in the NameNode, maximum control over encoded files is guaranteed. This page explains how to configure and use the erasure coding functionality of Hops. Apache HDFS stores 3 copies of your data to provide high-availability. So 1 petabyte of data actually requires 3 petabytes of storgae. For many organizations, this results in onorous storage costs. Hops-FS also supports erasure coding to reduce the storage required by by 44% compared to HDFS, while still providing high-availability for your data.


Compatibility
-------------

The erasure coding functionality is fully compatible to standard HDFS and availability of encoded files is ensured via fully transparent on the fly repairs on the client-side. Transparent repairs are provided through a special implementation of the FileSystem API and hence compatible to any existing code relying on this API. To enable transparent repairs, simply add the following configuration option to your HDFS configuration file.

.. code-block:: xml

	<property>
  		<name>fs.hdfs.impl</name>
  		<value>org.apache.hadoop.fs.ErasureCodingFileSystem</value>
  		<description>FileSystem implementation to be used with HDFS</description>
	</property>

Note that code relying on the use of DistributedFileSystem instead of the FileSystem interface needs to be updated.



.. _erasure-coding-configuration:

Configuration
---------------

The erasure coding API is flexibly configurable and hence comes with some new configuration options that are shown here. All configuration options can be set by creating an erasure-coding-site.xml in the Hops configuration folder. Note that Hops comes with reasonable default values for all of these values. However, erasure coding needs to be enabled manually.

.. code-block:: xml

	<property>
	  <name>dfs.erasure_coding.enabled</name>
	  <value>true</value>
	  <description>Enable erasure coding</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.codecs.json</name>
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
	  <description>Erasure coding codecs to be available to the API</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.parity_folder</name>
	  <value>/parity</value>
	  <description>The HDFS folder to store parity information in</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.recheck_interval</name>
	  <value>300000</value>
	  <description>How frequently should the system schedule encoding or repairs and check their state</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.repair_delay</name>
	  <value>1800000</value>
	  <description>How long should the system wait before scheduling a parity repair</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.parity_repair_delay</name>
	  <value>1800000</value>
	  <description>How long should the system wait before scheduling a parity repair</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.active_encoding_limit</name>
	  <value>10</value>
	  <description>Maximum number of active encoding jobs</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.active_repair_limit</name>
	  <value>10</value>
	  <description>Maximum number of active repair jobs</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.active_parity_repair_limit</name>
	  <value>10</value>
	  <description>Maximum number of active parity repair jobs</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.deletion_limit</name>
	  <value>100</value>
	  <description>Delete operations to be handle during one round</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.encoding_manager</name>
	  <value>io.hops.erasure_coding.MapReduceEncodingManager</value>
	  <description>Implementation of the EncodingManager to be used</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.block_rapair_manager</name>
	  <value>io.hops.erasure_coding.MapReduceBlockRepairManager</value>
	  <description>Implementation of the repair manager to be used</description>
	</property>


Java API
---------
The erasure coding API is exposed to the client through the DistributedFileSystem class. The following sections give examples on how to use its functionality. Note that the following examples rely on erasure coding being properly configured. Information about how to do this can be found in :ref:`erasure-coding-configuration`.


Creation of Encoded Files
~~~~~~~~~~~~~~~~~~~~~~~~~~

The erasure coding API offers the ability to request the encoding of a file while being created. Doing so has the benefit that file blocks can initially be placed in a way that the meets placements constraints for erasure-coded files without needing to rewrite them during the encoding process. The actual encoding process will take place asynchronously on the cluster.

.. code-block:: java

	Configuration conf = new Configuration();
	DistributedFileSystem dfs = (DistributedFileSystem) FileSystem.get(conf);
	// Use the configured "src" codec and reduce the replication to 1 after successful encoding
	EncodingPolicy policy = new EncodingPolicy("src" /* Codec id as configured */, (short) 1);
	// Create the file with the given policy and write it with an initial replication of 2
	FSDataOutputStream out = dfs.create(path, (short) 2,  policy);
	// Write some data to the stream and close it as usual
	out.close();
	// Done. The encoding will be executed asynchronously as soon as resources are available.


Multiple versions of the create function complementing the original versions with erasure coding functionality exist. For more information please refer to the class documentation.

Encoding of Existing Files
~~~~~~~~~~~~~~~~~~~~~~~~~~

The erasure coding API offers the ability to request the encoding for existing files. A replication factor to be applied after successfully encoding the file can be supplied as well as the desired codec. The actual encoding process will take place asynchronously on the cluster.

.. code-block:: java

	Configuration conf = new Configuration();
	DistributedFileSystem dfs = (DistributedFileSystem) FileSystem.get(conf);
	String path = "/testFile";
	// Use the configured "src" codec and reduce the replication to 1 after successful encoding
	EncodingPolicy policy = new EncodingPolicy("src" /* Codec id as configured */, (short) 1);
	// Request the asynchronous encoding of the file
	dfs.encodeFile(path, policy);
	// Done. The encoding will be executed asynchronously as soon as resources are available.


Reverting To Replication Only
~~~~~~~~~~~~~~~~~~~~~~~~~~
The erasure coding API allows to revert the encoding and to default to replication only. A replication factor can be supplied and is guaranteed to be reached before deleting any parity information.

.. code-block:: java

	Configuration conf = new Configuration();
	DistributedFileSystem dfs = (DistributedFileSystem) FileSystem.get(conf);
	// The path to an encoded file
	String path = "/testFile";
	// Request the asynchronous revocation process and set the replication factor to be applied
	 dfs.revokeEncoding(path, (short) 2);
	// Done. The file will be replicated asynchronously and its parity will be deleted subsequently.


Deletion Of Encoded Files
~~~~~~~~~~~~~~~~~~~~~~~~~~

Deletion of encoded files does not require any special care. The system will automatically take care of deletion of any additionally stored information.



.. _Apache Hadoop: http://hadoop.apache.org/releases.html
.. _configuration: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml
.. _service: http://link.springer.com/chapter/10.1007%2F978-3-319-19129-4_13
