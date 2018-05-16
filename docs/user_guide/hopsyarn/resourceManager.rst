.. _resource_manager:

===========================
ResourceManager
===========================

.. contents:: Contents
   :local:
   :depth: 2

Even though Hops-YARN allows to distribute the ResourceManager to have the scheduling running on one node (the Scheduler) and the resource tracking running on several other nodes (the ResourceTrackers) the configuration of the resource manager is similar to the configuration of Apache Hadoop YARN. When running in distributed mode all the nodes participating in the resource management should be configured as a ResourceManager would be configured. They will then automatically detect each other and elect a leader to be the Scheduler.

.. _adding/removing_resource_manager:
Adding/Removing a ResourceManager
---------------------------------

As the ResourceManagers automatically detect each other through the database adding a new ResourceManager consist simply in configuring and starting a new node as it would be done for the first started ResourceManager. The same way removing a resource manager consist simply in stopping the resource manager. If this resource manager was the scheduler, this will induce some delay in the ongoing scheduling as a new scheduler need to be elected, and need to recover the cluster state, but all scheduling operations will resume as soon as these operations are finished.
