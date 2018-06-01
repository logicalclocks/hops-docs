.. _quota-parameters:

===========================
Quota Management
===========================

In order to boost the performance and increase the parallelism of metadata operations the quota updates are applied asynchronously i.e. disk and namespace usage statistics are asynchronously updated in the background. Using asynchronous quota system it is possible that some users over consume namespace/disk space before the background quota system throws an exception. Following parameters controls how aggressively the quota subsystem updates the quota statistics. Quota management configuration parameters are defined in ``hdfs-site.xml`` file.

* **dfs.quota.enabled**:
  Enable/Disabled quota. By default quota is enabled.
* **dfs.namenode.quota.update.interval**:
  The quota update manager applies the outstanding quota updates after every dfs.namenode.quota.update.interval milliseconds.
* **dfs.namenode.quota.update.limit**:
  The maximum number of outstanding quota updates that are applied in each round.
