.. _yarn_unsupported_Features:

==============================
Removed/Replaced YARN Features
==============================

Hops-YARN is a drop-in replacement for Apache Hadoop YARN and it supports most of the `configuration` parameters defined for Apache Hadoop YARN. As we have completely rewritten the failover mechanism some recovery option are not required in Hops-YARN. Following is the list of YARN configurations that are not applicable in Hops-YARN.


* **ZooKeeper**
  ZooKeeper is no longer required as the coordination and membership `service` is implemented using the transactional shared memory (NDB). As a result the following options are not supported in Hops-YARN: yarn.resourcemanager.zk-address, yarn.resourcemanager.zk-num-retries, yarn.resourcemanager.zk-retry-interval-ms, yarn.resourcemanager.zk-state-store.parent-path, yarn.resourcemanager.zk-timeout-ms, yarn.resourcemanager.zk-acl, yarn.resourcemanager.zk-state-store.root-node.acl, yarn.resourcemanager.ha.automatic-failover.zk-base-path.
  |
* **StateStore**
  Hops-YARN in entirely designed to store its state in the transactional share memory (NDB). As a result DBRMStateStore is the only state store that is still supported. It follows that option specific to other state store are not supported in Hops-YARN: yarn.resourcemanager.fs.state-store.uri, yarn.resourcemanager.fs.state-store.retry-policy-spec.
  |
* **Administration commands**
  Two administration commands are now obsolete: **transitionToActive** and **transitionToStandby**. The selection of the active ResourceManager is now completely automatized and managed by the group membership service. As a result **transitionToActive** is not supported anymore.
  **transitionToStandby** does not present any interesting use case in Hops-YARN, if one want to remove a ResourceManager from the system they can simply stop it and the automatic failover will make sure that a new ResourceManager transparently replace it. Moreover, as the transition to active it automatized, it is possible that the leader election elects the resource that we just transitioned to standby to make it the "new" active ResourceManager.

As Hops-YARN is still at an early stage of is development, some features are still under development and not supported yet. Some the main unsupported features are: **Fail-over when running in distributed mode** and the **fair-scheduler**.
