===========================
Configuring Hops-YARN distributed mode
===========================

Hops-YARN distributed mode can be enabled by setting the following flags to true:

* **hops.yarn.resourcemanager.distributed-rt.enable**: Set to `true` to indicate that the system should work in distributed mode. Set it to true to run in distributed mode.

* **hops.yarn.resourcemanager.ndb-event-streaming.enable**: Set to `true` to indicate that the ResourceManager (scheduler) should use the streaming API to the database to receive updates on the state of NodeManagers. Set it to true if you want to use the streaming API for more performance.

* **hops.yarn.resourcemanager.ndb-rt-event-streaming.enable**: Set to `true` to indicate that that the ResourceTracker should use the streaming API to the database to receive updates on the state of NodeManagers. Set it to true if you want to use the streaming API for more performance.
