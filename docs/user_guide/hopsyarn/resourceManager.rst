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

As the ResourceManagers automatically detect each other through NDB adding a new ResourceManager consist simply in configuring and starting a new node as it would be done for the first started ResourceManager.
Removing a resourceManager is not supported yet in the distributed mode. In the non distributed mode stopping the ResourceManager is enough to remove it. If the stopped ResourceManager was in standby nothing will happen. If the stopped ResourceManager was the active ResrouceManager the failover will automatically be triggered and a new active ResourceManager will take the active role.
