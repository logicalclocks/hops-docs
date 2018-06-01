.. _hdfs_unsupported_Features:

===========================
Unsupported HDFS Features
===========================

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
	ZooKeeper is no longer required as the coordination and membership service. A coordination and membership management `service` is implemented using the transactional shared memory (NDB).


As HopsFS is under heavy development some features such as rolling upgrades and snapshots are not yet supported. These features will be activated in future releases.
