===========================
Batch Processing of Operations
===========================

.. contents:: Contents
   :local:
   :depth: 2

In Hops-YARN, RPCs are received by the ResourceManager that describe operations on the ``Applications Master Interface``, the ``Administrator Interface``, and the ``Client Interface``. RPCs for the ``Resource Tracker`` Interface are received by the ResourceTracker nodes.
For reasons of performance and consistency, the Hops-YARN resource manager processes incoming RPCs in batches. Hops-YARN first fills an **adaptive processing buffer** with a bounded-size batch of RPCs. If the batch size has not been filled before a timer expires (``hops.yarn.resourcemanager.batch.max.duration``), the batch is processed immediately. New RPCs are blocked until the accepted batch of RPCs has been processed. Once all of RPCs have been completely executed the state of the resource manager is pushed to the database and the next RPCs are accepted.
The size of the batch of rpc that are accepted is limited by two factors: the number of RPCs and the time for which this batch have been going. The first factor guaranty that the number of state change in the database will be limited and that the commit of the new state to the database won't be too long. The second factor guaranty that a new state will be committed in a given time even if few RPCs are received.

* **hops.yarn.resourcemanager.batch.max.size**: The maximum number of RPCs in a batch.

* **hops.yarn.resourcemanager.batch.max.duration**: The maximum time to wait before processing a batch of RPCs (default: 10 ms).

* **hops.yarn.resourcemanager.max.allocated.containers.per.request**: In very large clusters some application may try to allocate tens of thousands of containers at once. This can take few seconds and block any other RPC to be handled during this time, this is due to the RPCs batch system. In order to limit the impact of such big request it is possible to set this option to limit the number of containers an application get at each request. **This result in a suboptimal us of the cluster each time such application start**

Database back pressure
----------------------

In order to exercise back pressure when the database is overloaded we block the execution of new RPCs. We identify that the database is overloaded by looking at the length of the queue of operations waiting to be committed as well as the duration of individual commits. If the length of the queue becomes too long or the duration of any individutal commit becomes too long, we exercise back pressure on the RPCs.

* **hops.yarn.resourcemanager.commit.and.queue.threshold**: The upper bound on the length of the queue of operations waiting to be commited.

* **hops.yarn.resourcemanager.commit.queue.max.length**: The upper bound on the time each individual commit should take.

Proxy provider
--------------

* **yarn.client.failover-proxy-provider**: Two new proxy providers have been added to the existing ConfiguredRMFailoverProxyProvider

*  **ConfiguredLeaderFailoverHAProxyProvider**: this proxy provider has the same goal as the ConfiguredRMFailoverProxyProvider (connecting to the leading ResourceManager) but it uses the groupMembershipService where the ConfiguredRMFailoverProxyProvider goes through all the ResourceManagers present in the configuration file to find the leader. This allows the ConfiguredLeaderFailoverHAProxyProvider to be faster and to find the leader even if it is not present in the configuration file.

* **ConfiguredLeastLoadedRMFailoverHAProxyProvider**: this proxy provider establishes a connection with the ResourceTracker that has the lowest current load (least loaded). This proxy provider is to be used in distributed mode in order to balance the load coming from NodeManagers across ResourceTrackers.
