HopsFS User Guide
=================

Unsupported HDFS Features
-------------------------

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
------------------
