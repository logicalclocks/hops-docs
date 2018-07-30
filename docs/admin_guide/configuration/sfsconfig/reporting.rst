.. _block-reporting-parameteres:

===========================
Block Reporting
===========================

* **dfs.block.report.load.balancing.max.blks.per.time.window**:
  This is a global configuration parameter. The leader NameNode only allows certain number of blocks reports such that the maximum number of blocks that are processed by the block reporting sub-system of HopsFS does not exceed **dfs.block.report.load.balancing.max.blks.per.time.window** in a given block report processing time window.

* **dfs.block.report.load.balancing.time.window.size**
  This parameter determines the block report processing time window size. It is defined in milliseconds. If **dfs.block.report.load.balancing.max.blks.per.time.window** is set to one million and **dfs.block.report.load.balancing.time.window.size** is set to one minutes then the leader NameNode will ensure that at every minute at most 1 million blocks are accepted for processing by the admission control system of the filesystem.

* **dfs.blk.report.load.balancing.update.threashold.time**
  Using command ``hdfs namenode -setBlkRptProcessSize noOfBlks`` the parameter **dfs.block.report.load.balancing.max.blks.per.time.window** can be changed. The parameter is stored in the database and the NameNodes periodically read the new value from the database. This parameter determines how frequently a NameNode checks for changes in this parameter. The default is set to 60*1000 milliseconds.
  **dfs.blockreport.numbuckets** This parameter defines the number of buckets in the hash-based report. Reconfiguration requires a complete restart of the cluster, and datanodes and namenodes alike must share the same configuration value. ONLY USE THIS IN VERSION 2.8.2.5+.
