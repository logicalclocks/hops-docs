Hops-YARN User Guide
====================

Hops-YARN is very similar to Apache Hadoop YARN when it comes to using it. The goal of this section is to present the things that change. We first present some major features of Apache Hadoop YARN that have been removed or replaced in Hops-YARN. We then present how the different part of the YARN system (ResourceManager, NodeManager, Client) should be configured and used in Hops-YARN.

.. _Unsupported_Features:
Removed/Replaced YARN Features
------------------------------

Hops-YARN is a drop-in replacement for Apache Hadoop YARN and it supports most of the `configuration` parameters defined for Apache Hadoop YARN. As we have completely rewritten the failover mechanism some recovery option are not required in Hops-YARN. Following is the list of YARN configurations that are not applicable in Hops-YARN.


* **ZooKeeper**
  ZooKeeper is no longer required as the coordination and membership `service` is implemented using the transactional shared memory (NDB). As a result the following options are not supported in Hops-YARN: yarn.resourcemanager.zk-address, yarn.resourcemanager.zk-num-retries, yarn.resourcemanager.zk-retry-interval-ms, yarn.resourcemanager.zk-state-store.parent-path, yarn.resourcemanager.zk-timeout-ms, yarn.resourcemanager.zk-acl, yarn.resourcemanager.zk-state-store.root-node.acl, yarn.resourcemanager.ha.automatic-failover.zk-base-path.
|
* **StateStore**
  Hops-YARN in entirely designed to store its state in the transactional share memory (NDB). As a result NDBRMStateStore is the only state store that is still supported. It follows that option specific to other state store are not supported in Hops-YARN: yarn.resourcemanager.fs.state-store.uri, yarn.resourcemanager.fs.state-store.retry-policy-spec.
|
* **Administration commands**
  Two administration commands are now obsolete: **transitionToActive** and **transitionToStandby**. The selection of the active ResourceManager is now completely automatized and managed by the group membership service. As a result **transitionToActive** is not supported anymore.
  **transitionToStandby** does not present any interesting use case in Hops-YARN, if one want to remove a ResourceManager from the system they can simply stop it and the automatic failover will make sure that a new ResourceManager transparently replace it. Moreover, as the transition to active it automatized, it is possible that the leader election elects the resource that we just transitioned to standby to make it the "new" active ResourceManager.

As Hops-YARN is still at an early stage of is development, some features are still under development and not supported yet. Some the main unsupported features are: **Fail-over when running in distributed mode** and the **fair-scheduler**.

.. _resource_manager:
ResourceManager
---------------
Even though Hops-YARN allows to distribute the ResourceManager to have the scheduling running on one node (the Scheduler) and the resource tracking running on several other nodes (the ResourceTrackers) the configuration of the resource manager is similar to the configuration of Apache Hadoop YARN. When running in distributed mode all the nodes participating in the resource management should be configured as a ResourceManager would be configured. They will then automatically detect each other and elect a leader to be the Scheduler.

.. _adding/removing_resource_manager:
Adding/Removing a ResourceManager
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
As the ResourceManagers automatically detect each other through NDB adding a new ResourceManager consist simply in configuring and starting a new node as it would be done for the first started ResourceManager.
Removing a resourceManager is not supported yet in the distributed mode. In the non distributed mode stopping the ResourceManager is enough to remove it. If the stopped ResourceManager was in standby nothing will happen. If the stopped ResourceManager was the active ResrouceManager the failover will automatically be triggered and a new active ResourceManager will take the active role.

.. _yarn_clients:
YARN Clients
------------
Hops-YARN is fully compatible with Apache Hadoop YARN client. As in Apache Hadoop YARN the have to be configured with the list of all possible scheduler to be able to find the leader one and start communicating with it.

When running Hops-YARN client it is possible to configure it to use the ConfiguredLeaderFailoverHAProxyProvider as a yarn.client.failover-proxy-provider. This will allow the client to find the leader faster than going through all the possible leaders present in the configuration file. This will also allow the client to find the leader even if it is not present in the client configuration file, as long as one of the resourceManager present in the client configuration file is alive.

.. _yarn_node_manager:
YARN NodeManager:
-----------------
In non distributed mode the NodeManagers should be configured to use ConfiguredLeaderFailoverHAProxyProvider as a failover proxy provider. This allows them to automatically find the leading ResourceManager and to connect to it.

In distributed mode the NodeManagers should be configured to use ConfiguredLeastLoadedRMFailoverHAProxyProvider as a failover proxy provider. This allows them to automatically find the resourceTracker which is the least loaded and to connect to it.

.. _configuration: https://hadoop.apache.org/docs/r2.4.1/hadoop-yarn/hadoop-yarn-common/yarn-default.xml
.. _service: http://link.springer.com/chapter/10.1007%2F978-3-319-19129-4_13
