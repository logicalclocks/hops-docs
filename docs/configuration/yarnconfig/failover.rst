===========================
Configuring Hops-YARN fail-over
===========================

* **yarn.resourcemanager.scheduler.port**: The port used by the scheduler service(the port still need to be specified in yarn.resourcemanager.scheduler.address)

* **yarn.resourcemanager.resource-tracker.port**: The port used by the resource-tracker service (the port still need to be specified in yarn.resourcemanager.resource-trakcer.address)

* **yarn.resourcemanager.admin.port**: The port used by the admin service (the port still need to be specified in yarn.resourcemanager.admin.address)

* **yarn.resourcemanager.port**: The port used by the resource manager service (the port still need to be specified in yarn.resourcemanager.resourcemanager.address)

* **yarn.resourcemanager.groupMembership.address**: The address of the group membership service. The group membership service is used by the clients and node managers to obtain the list of alive resource managers.

* **yarn.resourcemanager.groupMembership.port**: The port used by the group membership service (the port still need to be specified in yarn.resourcemanager.groupMembership.address)

* **yarn.resourcemanager.ha.rm-ids**: Contain a list of ResourceManagers. This is used to establish the first connection to the group membership service.

* **yarn.resourcemanager.store.class**: Should be set to org.apache.hadoop.yarn.server.resourcemanager.recovery.NDBRMStateStore
