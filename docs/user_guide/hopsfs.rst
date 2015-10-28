HopsFS User Guide
=================

Unsupported HDFS Features
-------------------------

HopsFS is a drop-in replacement for HDFS and it supports most of the `configuration`_ parameters defined for Apache HDFS. As the architecture of HopsFS is fundamentally different from HDFS, some of the features such as journaling, secondary NameNode etc., are not required in HopsFS. Following is the list of HDFS features and configurations that are not applicable in HopsFS

.. _configuration: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml

* **Secondary NameNode**
	The secondary NameNode is no longer supported. HopsFS supports multiple active NameNodes. Thus **hdfs haadmin *** command; and **dfs.namenode.secondary.*** and **dfs.ha.*** configuration parameters are not supported in HopsFS.
* **Checkpoint Node and FSImage**
    HopsFS does not require checkpoint node as all the metadata is stored in highly available external database. Thus **hdfs dfsadmin -{saveNamespace | metaSave | restoreFailedStorage | rollEdits | fetchImage}** command; and **dfs.namenode.name.dir.***, **dfs.image.***, **dfs.namenode.checkpoint.*** configuration parameters are not supported in HopsFS.
* **Quorum Based Journaling** and **EditLog**
	The write ahead log (EditLog) is not needed as all the metadata mutations are stored in the highly available transactional memory. Thus **dfs.namenode.num.extra.edits.***, **dfs.journalnode.*** and **dfs.namenode.edits.*** configuration parameters are not supported in HopsFS.
* **NameNode Federation and ViewFS**
	In HDFS the namespace is statically partitioned among multiple namenodes to support large namespace. In essence these are independent HDFS clusters where ViewFS provides a unified view of the namespace. HDFS Federation and ViewFS are no longer supported as the namespace in HopsFS scales to billions of files and directories. Thus **dfs.nameservices.*** configuration parameters are not supported in HopsFS.
* **ZooKeeper**
	ZooKeeper is no long required as the coordination and membership `service`_ is implemented using the transactional shared memory. 
	

As HopsFS is under heavy development some features such as rolling upgrades and snapshots are not yet supported. These features will be activated in future releases. 



NameNodes
---------

Configuring HopsFS NameNode is very similar to configuring a HDFS NameNode. While configuring a single Hops NameNode, the configuration files are written as if it is the only NameNode in the system. The NameNode automatically detects other NameNodes using the shared transactional memory (NDB). 

Formating the Cluster
~~~~~~~~~~~~~~~~~~~~~
Running the format command on any NameNode **truncates** all the tables in the database and inserts default values in the tables. NDB atomically performs the **truncate** operation which can fail or take very long time to complete for very large tables. In such cases run the **/hdfs namenode -dropAndCreateDB** command first to drop and recreate the database schema followed by the **format** command to insert default values in the database tables. In NDB dropping and recreating a database is much quicker than truncating all the tables in the database. 


Adding/Removing NameNodes
~~~~~~~~~~~~~~~~~~~~~~~~~
As the namenodes are stateless any NameNode can be removed with out effecting the state of the system. All on going operations that fail due to stopping the NameNode are automatically forwarded by the clients to the remaining namenodes in the system.

Similarly, the clients automatically discover the newly started namenodes. See :ref:`client configuration parameters <client-conf-parameters>` that determines how quickly a new NameNode starts receiving requests from the existing clients. 


HopsFS Clients
--------------
For load balancing the clients uniformly distributes the filesystem operations among all the NameNodes in the system. HopsFS clients support **random**, **round-robin** and **sticky policies** to distribute the filesystem operations among the NameNodes. Random and round-robin policies are self explanatory. Using sticky policy the filesystem client randomly picks a NameNode and forwards all subsequent operation to the same NameNode. If the NameNode fails then the clients randomly picks another NameNode. 

In published Hadoop workloads, metadata accesses follow a heavy-tail distribution where 3% of files account for 80% of accesses. This means that caching
recently accessed metadata at NameNodes could give a significant performance boost. Each NameNode has a local cache that stores INode objects for recently accessed files and directories. Usually, the clients read/write files in the same sub-directory. Using sticky policies lowers the latencies for filesystem operations as most of the path components are already available in the NameNode cache.   

When HopsFS is initialized it selects a valid NameNode from **dfs.namenodes.rpc.addresses** or **fs.default.name** configuration parameters. Using the NameNode the client then acquires an updated list of all the NameNodes in the system. Therefore at least one of the NameNodes addresses defined by theses configuration parameters must belong to an alive NameNode. During initialization the client retries if it encounters a dead NameNode. The client initialization fails if all the NameNode addresses are invalid. 

Compatibility with HDFS Clients
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
HopsFS is fully compatible with HDFS clients, although they do not distribute operations over NameNodes, as they assume there is a single active NameNode. 


Datanodes
---------
The datanodes periodically acquire an updated list of NameNodes in the system and establish a connection (register) with the new NameNodes. Like clients, the datanodes also uniformly distribute the filesystem operations among all the NameNodes in the system. Currently the datanodes only support round-robin policy to distribute the filesystem operations. 


.. _Apache Hadoop: http://hadoop.apache.org/releases.html
.. _configuration: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml
.. _service: http://link.springer.com/chapter/10.1007%2F978-3-319-19129-4_13




