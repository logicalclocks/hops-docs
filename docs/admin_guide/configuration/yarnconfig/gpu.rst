==================================
Configuring Hops YARN GPU support
==================================

In order for a NodeManager to offers GPUs to be scheduled by the ResourceManager certain configuration properties need to be set.

Configuration parameters:
=================

* **yarn.nodemanager.resource.gpus.enabled**: Boolean ``true`` or ``false`` depending on if the NodeManager should offer GPUs from the machine to the scheduler Default, ``false``.

* **yarn.nodemanager.resource.gpus**: Number of GPUs to offer to the scheduler Default, ``0``.
    
* **yarn.nodemanager.gpu.management-impl**: Implementation class to query system for GPUs. For NVIDIA GPUs use ``io.hops.management.nvidia.NvidiaManagementLibrary`` for AMD use ``io.hops.management.amd.AMDManagementLibrary``

* **yarn.scheduler.capacity.resource-calculator**: Must be set to ``org.apache.hadoop.yarn.util.resource.DominantResourceCalculatorGPU``

* **yarn.nodemanager.container-executor.class**: Must be set to ``org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor``

* **yarn.nodemanager.linux-container-executor.resources-handler.class**: Must be set to ``org.apache.hadoop.yarn.server.nodemanager.util.CgroupsLCEResourcesHandlerGPU``

When the number of GPUs is changed the Cgroup hierarchy needs to be deleted manually. Assuming the Cgroup path is ``/sys/fs/cgroup`` then issue the following command *sudo rmdir /sys/fs/cgroup/devices/hops-yarn*