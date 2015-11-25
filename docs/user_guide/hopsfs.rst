HopsFS User Guide
=================

.. _Unsupported_Features:
Unsupported HDFS Features
-------------------------


HopsFS is a drop-in replacement for HDFS and it supports most of the `configuration`_ parameters defined for Apache HDFS. As the architecture of HopsFS is fundamentally different from HDFS, some of the features such as journaling, secondary NameNode etc., are not required in HopsFS. Following is the list of HDFS features and configurations that are not applicable in HopsFS

.. _configuration: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml

* **Secondary NameNode**
	The secondary NameNode is no longer supported. HopsFS supports multiple active NameNodes. Thus **hdfs haadmin *** command; and **dfs.namenode.secondary.*** and **dfs.ha.*** configuration parameters are not supported in HopsFS.
* **Checkpoint Node and FSImage**
    HopsFS does not require checkpoint node as all the metadata is stored in NDB. Thus **hdfs dfsadmin -{saveNamespace | metaSave | restoreFailedStorage | rollEdits | fetchImage}** command; and **dfs.namenode.name.dir.***, **dfs.image.***, **dfs.namenode.checkpoint.*** configuration parameters are not supported in HopsFS.
* **Quorum Based Journaling** and **EditLog**
	The write ahead log (EditLog) is not needed as all the metadata mutations are stored in NDB. Thus **dfs.namenode.num.extra.edits.***, **dfs.journalnode.*** and **dfs.namenode.edits.*** configuration parameters are not supported in HopsFS.
* **NameNode Federation and ViewFS**
	In HDFS the namespace is statically partitioned among multiple namenodes to support large namespace. In essence these are independent HDFS clusters where ViewFS provides a unified view of the namespace. HDFS Federation and ViewFS are no longer supported as the namespace in HopsFS scales to billions of files and directories. Thus **dfs.nameservices.*** configuration parameters are not supported in HopsFS.
* **ZooKeeper**
	ZooKeeper is no longer required as the coordination and membership service. A coordination and membership management `service`_ is implemented using the transactional shared memory (NDB). 
	

As HopsFS is under heavy development some features such as rolling upgrades and snapshots are not yet supported. These features will be activated in future releases. 



NameNodes
---------

Configuring HopsFS NameNode is very similar to configuring a HDFS NameNode. While configuring a single Hops NameNode, the configuration files are written as if it is the only NameNode in the system. The NameNode automatically detects other NameNodes using NDB. 

See :ref:`section <format_cluster>` for instructions for formating the filesystem. 

NameNode Caches
~~~~~~~~~~~~~~~

In published Hadoop workloads, metadata accesses follow a heavy-tail distribution where 3% of files account for 80% of accesses. This means that caching recently accessed metadata at NameNodes could give a significant performance boost. Each NameNode has a local cache that stores INode objects for recently accessed files and directories. Usually, the clients read/write files in the same sub-directory. Using ``RANDOM_STICKY``  load balancing policy to distribute filesystem operations among the NameNodes lowers the latencies for filesystem operations as most of the path components are already available in the NameNode cache. See :ref:`HopsFS clients <hopsfs-clients>` and :ref:`cache configuration parameters <cache-parameters>` for more details. 


Adding/Removing NameNodes
~~~~~~~~~~~~~~~~~~~~~~~~~
As the namenodes are stateless any NameNode can be removed with out effecting the state of the system. All on going operations that fail due to stopping the NameNode are automatically forwarded by the clients to the remaining namenodes in the system.

Similarly, the clients automatically discover the newly started namenodes. See :ref:`client configuration parameters <client-conf-parameters>` that determines how quickly a new NameNode starts receiving requests from the existing clients. 


.. _hopsfs-clients:

HopsFS Clients
--------------
For load balancing the clients uniformly distributes the filesystem operations among all the NameNodes in the system. HopsFS clients support ``RANDOM``, ``ROUND_ROBIN``, and ``RANDOM_STICKY`` policies to distribute the filesystem operations among the NameNodes. Random and round-robin policies are self explanatory. Using sticky policy the filesystem client randomly picks a NameNode and forwards all subsequent operation to the same NameNode. If the NameNode fails then the clients randomly picks another NameNode. This maximizes the NameNode cache hits. 

When HopsFS is initialized it selects a valid NameNode from **dfs.namenodes.rpc.addresses** or **fs.default.name** configuration parameters. Using the NameNode the client then acquires an updated list of all the NameNodes in the system. Therefore at least one of the NameNodes addresses defined by theses configuration parameters must belong to an alive NameNode. During initialization the client retries if it encounters a dead NameNode. The client initialization fails if all the NameNode addresses are invalid. 

:ref:`Here <client-conf-parameters>` is a complete list of client configuration parameters.

Compatibility with HDFS Clients
-------------------------------
HopsFS is fully compatible with HDFS clients, although they do not distribute operations over NameNodes, as they assume there is a single active NameNode. 


Datanodes
---------
The datanodes periodically acquire an updated list of NameNodes in the system and establish a connection (register) with the new NameNodes. Like clients, the datanodes also uniformly distribute the filesystem operations among all the NameNodes in the system. Currently the datanodes only support round-robin policy to distribute the filesystem operations. 


HopsFS Async Quota Management
-----------------------------

In HopsFS the commands and the APIs for quota management are identical to HDFS. In HDFS all Quota management operations are performed synchronously while in HopsFS Quota management is performed asynchronously for performance reasons. In the following example maximum namespace quota for ``/QDir`` is set to 10. When a new sub-directory or a file is created in this folder then the quota update information propagates up the filesystem tree until it reaches ``/QDir``. Each quota update propagation operation is implemented as an independent transaction. 

.. figure:: ../imgs/quota-update.png
  :alt: HopsFS Quota Update 
  :scale: 100
  :figclass: align-center

  HopsFS Quota Update
  
For write heavy workloads a user might be able to consume more diskspace/namespace than it is allowed before the filesystem recognizes that the quota limits have been violated. After the quota updates are applied the filesystem will not allow the use to further violate the quota limits. In industry write operation are a tiny fraction of the workload. Additionally, considering the size of the filesystem we think this is a small trade off for achieving high throughput for read only operation that often comprise 90-95% a typical filesystem workload. 


In HopsFS asynchronous quota updates are highly optimized. We bath the quota updates wherever possible.  :ref:`Here <quota-parameters>` is a complete list of parameters that determines how aggressively the quota updates are applied. 


   
   

.. _Apache Hadoop: http://hadoop.apache.org/releases.html
.. _configuration: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml
.. _service: http://link.springer.com/chapter/10.1007%2F978-3-319-19129-4_13






