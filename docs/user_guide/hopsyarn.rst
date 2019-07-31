Hops-YARN User Guide
====================

Hops-YARN is a drop-in replacement for Apache Hadoop YARN and it supports most of the `configuration` parameters defined for Apache Hadoop YARN. As we have replaced ZooKeeper by the database for the failover mechanism some configurations and features are different or not supported. Following is the list of YARN configurations and features that are different in Hops-YARN.


* **ZooKeeper**
  ZooKeeper is no longer required as the coordination and membership `service` is implemented using the transactional shared memory (NDB). As a result the following options are not supported in Hops-YARN: yarn.resourcemanager.ha.failover-controller.active-standby-elector.zk.retries, yarn.resourcemanager.zk-state-store.parent-path, yarn.resourcemanager.zk-state-store.root-node.acl, yarn.resourcemanager.ha.automatic-failover.embedded, yarn.resourcemanager.ha.automatic-failover.zk-base-path, yarn.resourcemanager.zk-appid-node.split-index, yarn.resourcemanager.zk-delegation-token-node.split-index, yarn.resourcemanager.zk-max-znode-size.bytes, yarn.scheduler.configuration.zk-store.parent-path.
  |
* **StateStore**
  Hops-YARN is entirely designed to store its state in the transactional share memory (NDB).  DBRMStateStore is the only state store that is still actively. Other state stores are still present (at the exception fo the ones requiring ZooKeeper) but we do not guaranty their compatibility with the new features introduced in HOPS. As a result, we advise to only use the DBRMStateStore.
  |
* **Administration commands**
  Two administration commands are not supported: **transitionToActive** and **transitionToStandby**. The selection of the active ResourceManager is completely automatized and managed by the group membership service and these two commands would interfere with its functioning.
  If one wants to remove a ResourceManager from the system they can simply stop it and the automatic failover will make sure that a new ResourceManager transparently replaces it.
  |
* **Federated YARN**
  Federated Yarn currently relies on ZooKeeper. We have not implemented the Zookeeper replacement for federated Hops-YARN and are as a result not currently supporting federated YARN.
  |
* **Fair Scheduler**  
  We have focussed our development on the Capacity Scheduler and do not guaranty that the fair scheduler support all of the HOPS Yarn features.
  |
* **YARN Service**  
  YARN Service relies heavily on ZooKeeper, which makes it incompatible with Hops YARN.

