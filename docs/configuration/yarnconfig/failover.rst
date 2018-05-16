==================================================
 Configuring Hops-YARN fail-over and Distribution
==================================================

The main fail-over mechanism of Hops-YARN are identical to the Hadoop Yarn fail-over mechanism and use the same configuration. As a result, we invite you to have a look at the Hadopp Yarn configuration in order to set up your fail-over configuration.
Our modifications of the fail-over mechanism result in few new features and a limitation in the state store that can be used to store the cluster state:

New Fail-over Features:
=======================

* **yarn.resourcemanager.groupMembership.address**: The address of the group membership service. The group membership service is used by the clients and node managers to obtain the list of alive resource managers.

* **yarn.resourcemanager.group_membership.client.thread-count**: The number of thread used by the group membership service the serve http requests. By default, it is 1.
  
Proxy provider
--------------

* **yarn.client.failover-proxy-provider**: Two new proxy providers have been added to the existing ConfiguredRMFailoverProxyProvider

  - **ConfiguredLeaderFailoverHAProxyProvider**: this proxy provider has the same goal as the ConfiguredRMFailoverProxyProvider (connecting to the leading ResourceManager) but it uses the groupMembershipService where the ConfiguredRMFailoverProxyProvider goes through all the ResourceManagers present in the configuration file to find the leader. This allows the ConfiguredLeaderFailoverHAProxyProvider to be faster and to find the leader even if it is not present in the configuration file.

  - **ConfiguredLeastLoadedRMFailoverHAProxyProvider**: this proxy provider establishes a connection with the ResourceTracker that has the lowest current load (least loaded). This proxy provider is to be used in distributed mode in order to balance the load coming from NodeManagers across ResourceTrackers.

Suported State Store:
=====================
Since Hops Yarn rely on the distributed database for the group membership management and its distributed model it was chosen not to support the existing state store to focus only on the database state store.

* **yarn.resourcemanager.store.class**: Should be set to org.apache.hadoop.yarn.server.resourcemanager.recovery.DBRMStateStore

Distributed Mode
================
Hops-YARN distributed mode can be enabled by setting the following flags to true:

* **yarn.client.failover-distributed**: Set to `true` to indicate that the system should work in distributed mode. Set it to true to run in distributed mode.

In order to run efficiently, the distributed mode relies on the database streaming mechanism. The port on which the database is listening for streaming requests can be configured with the following configuration:

* **hops.yarn.resourcemanager.event-streaming.db.port**: the port on which the database is listening for streaming request, by default 1186

