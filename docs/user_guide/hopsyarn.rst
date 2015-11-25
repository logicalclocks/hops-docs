Hops Yarn User Guide
====================

.. _Unsupported_Features:
Unsupported Yarn Features
-------------------------

Hops Yarn is a drop-in replacement for Apache Hadoop Yarn and it supports most of the `configuration`_ parameters defined for Apache Hadoop Yarn. As we have completely rewritten the failover mechanism some recovery option are not required in Hops Yarn. Following is the list of Yarn configurations that are not applicable in Hops Yarn.


* **ZooKeeper**
  ZooKeeper is no longer required as the coordination and membership `service`_ is implemented using the transactional shared memory (NDB). As a result the following options are not supported in Hops Yarn: yarn.resourcemanager.zk-address, yarn.resourcemanager.zk-num-retries, yarn.resourcemanager.zk-retry-interval-ms, yarn.resourcemanager.zk-state-store.parent-path, yarn.resourcemanager.zk-timeout-ms, yarn.resourcemanager.zk-acl, yarn.resourcemanager.zk-state-store.root-node.acl, yarn.resourcemanager.ha.automatic-failover.zk-base-path.
  
* **StateStore**
  Hops Yarn in entirely designed to store its state in the transactional share memory (NDB). As a result NDBRMStateStore is the only state store that is still supported. It follows that option specific to other state store are not supported in Hops Yarn: yarn.resourcemanager.fs.state-store.uri, yarn.resourcemanager.fs.state-store.retry-policy-spec.

As Hops Yarn is still at an early stage of is development, some features are still under development and not supported yet. Some the main unsupported features are: Fail-over when running in distributed mode and the fair-scheduler.

.. _resource_manager:
ResourceManager
---------------
Even though Hops Yarn allows to distribute the ResourceManager to have the scheduling running on one node (the Scheduler) and the resource tracking running on several other nodes (the ResourceTrackers) the configuration of the resource manager is similar to the configuration of Apache Hadoop Yarn. When running in distributed mode all the nodes participating in the resource management should be configured as a ResourceManager would be configured. They will then automatically detect each other and elect a leader to be the Scheduler.

.. _format_cluster:
Formatting the Cluster
~~~~~~~~~~~~~~~~~~~~~~
Formatting the table corresponding to Yarn NDB is done the same way as formatting the cluster in HopsFS.

.. _adding/removing_resource_manager:
Adding/Removing ResourceManager
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
As the ResourceManagers automatically detect each other through NDB adding a new ResourceManager consist simply in configuring and starting a new node as it would be done for the first started ResourceManager.
Removing a resourceManager is not supported yet in the distributed mode. In the non distributed mode stopping the ResourceManager is enough to remove it. If the stopped ResourceManager was in standby nothing will happen. If the stopped ResourceManager was the active ResrouceManager the failover will automatically be triggered and a new active ResourceManager will take the active role.

.. _yarn_clients:
Yarn Clients
------------
Hops Yarn is fully compatible with Apache Hadoop Yarn client. As in Apache Hadoop Yarn the have to be configured with the list of all possible scheduler to be able to find the leader one and start communicating with it.

When running Hops Yarn client it is possible to configure it to use the ConfiguredLeaderFailoverHAProxyProvider as a yarn.client.failover-proxy-provider. This will allow the client to find the leader faster than going through all the possible leaders present in the configuration file. This will also allow the client to find the leader even if it is not present in the client configuration file, as long as one of the resourceManager present in the client configuration file is alive.

.. _yarn_node_manager:
Yarn NodeManager:
-----------------
In non distributed mode the NodeManagers should be configured to use ConfiguredLeaderFailoverHAProxyProvider as a failover proxy provider. This allows them to automatically find the leading ResourceManager and to connect to it.

In distributed mode the NodeManagers should be configured to use ConfiguredLeastLoadedRMFailoverHAProxyProvider as a failover proxy provider. This allows them to automatically find the resourceTracker which is the least loaded and to connect to it.

.. _configuration: https://hadoop.apache.org/docs/r2.4.1/hadoop-yarn/hadoop-yarn-common/yarn-default.xml
.. _service: http://link.springer.com/chapter/10.1007%2F978-3-319-19129-4_13
