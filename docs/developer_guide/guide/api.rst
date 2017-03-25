===========================
Erasure Coding API Access
===========================

.. contents:: Contents
   :local:
   :depth: 2


HopsFS provides erasure coding functionality in order to decrease storage costs without the loss of high-availability. Hops offers a powerful, on a per file basis configurable, erasure coding API. Codes can be freely configured and different configurations can be applied to different files. Given that Hops monitors your erasure-coded files directly in the NameNode, maximum control over encoded files is guaranteed. This page explains how to configure and use the erasure coding functionality of Hops. Apache HDFS stores 3 copies of your data to provide high-availability. So, 1 petabyte of data actually requires 3 petabytes of storage. For many organizations, this results in enormous storage costs. HopsFS also supports erasure coding to reduce the storage required by by 44% compared to HDFS, while still providing high-availability for your data.


Java API
--------

The erasure coding API is exposed to the client through the DistributedFileSystem class. The following sections give examples on how to use its functionality. Note that the following examples rely on erasure coding being properly configured. Information about how to do this can be found in :ref:`erasure-coding-configuration`.


Creation of Encoded Files
-------------------------

The erasure coding API offers the ability to request the encoding of a file while being created. Doing so has the benefit that file blocks can initially be placed in a way that the meets placements constraints for erasure-coded files without needing to rewrite them during the encoding process. The actual encoding process will take place asynchronously on the cluster.

.. code-block:: java

	Configuration conf = new Configuration();
	DistributedFileSystem dfs = (DistributedFileSystem) FileSystem.get(conf);
	// Use the configured "src" codec and reduce
	// the replication to 1 after successful encoding
	EncodingPolicy policy = new EncodingPolicy("src" /* Codec id as configured */,
	                        (short) 1);
	// Create the file with the given policy and
	// write it with an initial replication of 2
	FSDataOutputStream out = dfs.create(path, (short) 2,  policy);
	// Write some data to the stream and close it as usual
	out.close();
	// Done. The encoding will be executed asynchronously
	// as soon as resources are available.


Multiple versions of the create function complementing the original versions with erasure coding functionality exist. For more information please refer to the class documentation.

Encoding of Existing Files
--------------------------

The erasure coding API offers the ability to request the encoding for existing files. A replication factor to be applied after successfully encoding the file can be supplied as well as the desired codec. The actual encoding process will take place asynchronously on the cluster.

.. code-block:: java

	Configuration conf = new Configuration();
	DistributedFileSystem dfs = (DistributedFileSystem) FileSystem.get(conf);
	String path = "/testFile";
	// Use the configured "src" codec and reduce the replication to 1
	// after successful encoding
	EncodingPolicy policy = new EncodingPolicy("src" /* Codec id as configured */,
	                                 (short) 1);
	// Request the asynchronous encoding of the file
	dfs.encodeFile(path, policy);
	// Done. The encoding will be executed asynchronously
	// as soon as resources are available.


Reverting To Replication Only
-----------------------------
The erasure coding API allows to revert the encoding and to default to replication only. A replication factor can be supplied and is guaranteed to be reached before deleting any parity information.

.. code-block:: java

	Configuration conf = new Configuration();
	DistributedFileSystem dfs = (DistributedFileSystem) FileSystem.get(conf);
	// The path to an encoded file
	String path = "/testFile";
	// Request the asynchronous revocation process and
	// set the replication factor to be applied
	 dfs.revokeEncoding(path, (short) 2);
	// Done. The file will be replicated asynchronously and
	// its parity will be deleted subsequently.


Deletion Of Encoded Files
-------------------------

Deletion of encoded files does not require any special care. The system will automatically take care of deletion of any additionally stored information.


.. _Apache Hadoop: http://hadoop.apache.org/releases.html
.. _Hadoop configuration parameters: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml
.. _service: http://link.springer.com/chapter/10.1007%2F978-3-319-19129-4_13
