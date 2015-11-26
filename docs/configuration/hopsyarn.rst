.. _hops_yarn_Configuration (yarn-site.xml):
Hops Yarn Configuration
========================

Hops Yarn configuration is very similar to the Apache Hadoop Yarn configuration. Few extra configuration are needed to configure the new services provided by Hops Yarn. This section presents the new/modified configuration parameters for Hops Yarn. All the configuration parameters are defined in ``yarn-site.xml``.

Configuring Hops-Yarn fail-over
-------------------------------
* **yarn.resourcemanager.scheduler.port**: The port used by the scheduler service(the port still need to be specified in yarn.resourcemanager.scheduler.address)

* **yarn.resourcemanager.resource-tracker.port**: The port used by the resource-tracker service (the port still need to be specified in yarn.resourcemanager.resource-trakcer.address)

* **yarn.resourcemanager.admin.port**: The port used by the admin service (the port still need to be specified in yarn.resourcemanager.admin.address)

* **yarn.resourcemanager.port**: The port used by the resource manager service (the port still need to be specified in yarn.resourcemanager.resourcemanager.address)

* **yarn.resourcemanager.groupMembership.address**: The address of the group membership service. The group membership service is used by the clients and node managers to obtain the list of alive resource managers.

* **yarn.resourcemanager.groupMembership.port**: The port used by the group membership service (the port still need to be specified in yarn.resourcemanager.groupMembership.address)

* **yarn.resourcemanager.ha.rm-ids**: Contain a list of ResourceManagers. This is used to establish the first connection to the group membership service.

* **yarn.resourcemanager.store.class**: Should be set to org.apache.hadoop.yarn.server.resourcemanager.recovery.NDBRMStateStore

RPCs batchs
...........
In order to push coherent states to the database Hops-Yarn resource manager process the incoming RPCs by batch. Hops-Yarn first accept a limited number of RPCs. Once this limit is reached the following RPCs are blocked until the accepted RPCs have been executed. The accepted RPCs are then executed. Once all of them have been completely executed the state of the resource manager is pushed to the database and the next RPCs are accepted.
The size of the batch of rpc that are accepted is limited by two factors: the number of RPCs and the time for which this batch have been going. The first factor guaranty that the number of state change in the database will be limited and that the commit of the new state to the database won't be too long. The second factor guaranty that a new state will be committed in a given time even if few RPCs are received.

* **hops.yarn.resourcemanager.batch.max.size**: The maximum number of RPCs in a batch. 

* **hops.yarn.resourcemanager.batch.max.duration**: The maximum time before to finish a batch of RPCs.

* **hops.yarn.resourcemanager.max.allocated.containers.per.request**: In very large clusters some application may try to allocate tens of thousands of containers at once. This can take few seconds and block any other RPC to be handled during this time, this is due to the RPCs batch system. In order to limit the impact of such big request it is possible to set this option to limit the number of containers an application get at each request. **This result in a suboptimal us of the cluster each time such application start**

Database back pressure
......................

In order to exercise back pressure when the database is overloaded we block the execution of new RPCs when the queue of state waiting to be committed become too big or when the duration of any single commit is too long.

* **hops.yarn.resourcemanager.commit.and.queue.threshold**: The maximum size of the queue of states waiting to be commited.

* **hops.yarn.resourcemanager.commit.queue.max.length**: The maximum time each individual commit should take.

Proxy provider
..............
* **yarn.client.failover-proxy-provider**: Two new proxy providers have been added to the existing ConfiguredRMFailoverProxyProvider

     *  **ConfiguredLeaderFailoverHAProxyProvider**: this proxy provider has the same goal as the ConfiguredRMFailoverProxyProvider (connecting to the leading resourceManager) but it uses the groupMembershipService where the ConfiguredRMFailoverProxyProvider goes through all the resourceManager present in the configuration file to find the leader. This allows the ConfiguredLeaderFailoverHAProxyProvider to be faster and to find the leader even if it is not present in the configuration file.
     * **ConfiguredLeastLoadedRMFailoverHAProxyProvider**: this proxy provider establish a connection with the resourceTracker which is the least loaded. This proxy provider is to be used in distributed mode in order to have the NodeManagers connect to the appropriate resourceTracker.

Configuring Hops-Yarn distributed mode
--------------------------------------
Keep in mind that the distributed mode is under heavy development. As such, it is unstable and does not provide important features.

* **hops.yarn.resourcemanager.distributed-rt.enable**: Boolean indicating is the system should work in distributed mode. Set it to true to run in distributed mode.

* **hops.yarn.resourcemanager.ndb-event-streaming.enable**: Boolean that indicate if the retrieving of the state of the NodeManagers by the scheduler should be done through the streaming api of the database. Set it to true if you want to use the streaming api for more performance.

* **hops.yarn.resourcemanager.ndb-rt-event-streaming.enable**: Boolean that indicate if the retrieving of the state of the NodeManagers by the ResourceTrackers should be done through the streaming api of the database. Set it to true if you want to use the streaming api for more performance.

