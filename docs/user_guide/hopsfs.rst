******************
HopsFS User Guide
******************

HopsFS is a drop-in replacement for HDFS and it supports most of the `configuration`_ parameters defined for Apache HDFS. Following is the list of HDFS features and configurations that are not applicable in HopsFS

.. _configuration: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml

* **Secondary NameNode**
	The secondary NameNode is no longer supported. HopsFS supports multiple NameNodes and all the NameNodes are active. Thus **hdfs haadmin *** command; and **dfs.namenode.secondary.*** and **dfs.ha.*** configuration parameters are not supported in HopsFS.
* **Checkpoint Node**
    HopsFS does not require checkpoint node as all the metadata is stored in highly available external database. Thus **dfs.namenode.checkpoint.*** configuration parameters are not supported in HopsFS.
* **EditLog**
	The write ahead log (EditLog) is not needed as all the metadata mutations are stored in the highly available transactional memory. Thus **dfs.namenode.num.extra.edits.*** and **dfs.namenode.edits.*** configuration parameters are not supported in HopsFS.
* **FSImage** 
	We don’t need to store checkpoints of the metadata (FSImage) as NameNodes in HopsFS are stateless and metadata is stored in the external metadata store. Thus **hdfs dfsadmin -saveNamespace|metaSave|restoreFailedStorage|rollEdits|fetchImage** commands; and **dfs.namenode.name.dir.*** and **dfs.image.*** configuration parameters are not supported in HopsFS.
* **Quorum Based Journaling**
	Replaced by the external metadata store. Thus **dfs.journalnode.*** configuration parameters are not supported in HopsFS.
* **NameNode Federation and ViewFS**
	In HDFS the namespace is statically partitioned among multiple namenodes to support large namespace. In essence these are independent HDFS clusters where ViewFS provides a unified view of the namespace. HDFS Federation and ViewFS are no longer supported as the namespace in HopsFS scales to billions of files and directories. Thus **dfs.nameservices.*** configuration parameters are not supported in HopsFS.
* **ZooKeeper**
	ZooKeeper is no long required as the coordination and membership `service`_ is implemented using the transactional shared memory. 
	

Besides the unsupported features, there are some commands that are not currently supported as HopsFS is under heavy development. These commands will be activated in future releases. 

* **hdfs dfsadmin rollingUpgrade ***
* **hdfs dfadmin -allowSnapshot**
* **hdfs dfadmin -disallowSnapshot**


Formating NameNode
==============

Erasure Coding
==============
HopsFS provides erasure coding functionality in order to decrease storage costs without the loss of high-availability. Hops offers a powerful, on a per file basis configurable, erasure coding API. Codes can be freely configured and different configurations can be applied to different files. Given that Hops monitors your erasure-coded files directly in the NameNode, maximum control over encoded files is guaranteed. This page explains how to configure and use the erasure coding functionality of Hops. Apache HDFS stores 3 copies of your data to provide high-availability. So, 1 petabyte of data actually requires 3 petabytes of storage. For many organizations, this results in enormous storage costs. HopsFS also supports erasure coding to reduce the storage required by by 44% compared to HDFS, while still providing high-availability for your data.


Compatibility
-------------

The erasure coding functionality is fully compatible to standard HDFS and availability of encoded files is ensured via fully transparent on the fly repairs on the client-side. Transparent repairs are provided through a special implementation of the filesystem API and hence compatible to any existing code relying on this API. To enable transparent repairs, simply add the following configuration option to your HDFS configuration file.

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


.. _service: http://link.springer.com/chapter/10.1007%2F978-3-319-19129-4_13
