===============================
Distributed Unique ID generator
===============================

ClusterJ API does not support any means to auto generate primary keys. Unique key generation is left to the application. Each NameNode has an ID generation daemon. ID generator keeps pools of pre-allocated IDs. The ID generation daemon keeps track of IDs for inodes, blocks and quota entities. Distributed unique ID generator configuration parameters are defined in ``hdfs-site.xml``.

* **dfs.namenode.quota.update.id.batchsize**, **dfs.namenode.inodeid.batchsize**, **dfs.namenode.blockid.batchsize**:
  When the ID generator is about to run out of the IDs it pre-fetches a batch of new IDs. These parameters defines the prefetch batch size for Quota, inodes and blocks updates respectively.
* **dfs.namenode.quota.update.updateThreshold**, **dfs.namenode.inodeid.updateThreshold**, **dfs.namenode.blockid.updateThreshold**:
  These parameters define when the ID generator should pre-fetch new batch of IDs. Values for these parameter are defined as percentages i.e. 0.5 means prefetch new batch of IDs if 50 percent of the IDs have been consumed by the NameNode.
* **dfs.namenode.id.updateThreshold**:
  It defines how often the IDs Monitor should check if the ID pools are running low on pre-allocated IDs.
