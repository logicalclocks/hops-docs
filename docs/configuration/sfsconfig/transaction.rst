===========================
Distributed Transaction Hints
===========================

In HopsFS the metadata is partitioned using the inodes' id. HopsFS tries to to enlist the transactional filesystem operation on the database node that holds the metadata for the file/directory being manipulated by the operation. Distributed transaction hints configuration parameteres are defined in ``hdfs-site.xml`` file.

* **dfs.ndb.setpartitionkey.enabled**: (true/false)
  Enable/Disable transaction partition key hint.
* **dfs.ndb.setrandompartitionkey.enabled**: (true/false)
  Enable/Disable random partition key hint when HopsFS fails to determine appropriate partition key for the transactional filesystem operation.
