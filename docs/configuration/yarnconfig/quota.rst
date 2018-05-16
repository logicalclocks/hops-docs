==================================
Configuring Hops-YARN quota system
==================================

In order to set a price for the different cluster resources and to charge applications fine way, but without causing too much load on the resource manager and the database, several configuration parameters need to be tuned:

The bases:
==========
These are the minimum configuration in order to set up the quota system:

* **yarn.resourcemanager.quota.containers.log.period**: Time, in milliseconds, between two evaluations of the containers status. This is the frequency at which the quota system is evaluating application resources utilization, we also call it a tick. The lower this value the finer the cluster utilization evaluation (more precision on exactly when a container changed state), but the higher the load on the resource manager and database. Default: 1000.

* **yarn.resourcemanager.quota.minTicksCharge**: The minimum number of ticks for which a container will be charged. If a container runs less than this number of ticks it will still be charged for this number of ticks. This allows the system to charge for the time to allocate and start the container, during which the container is not running, but still using resources. This also avoids short running container polluting the scheduling system by popping up and down unnecessarily. Default: 10.
    
* **yarn.resourcemanager.quota.minimum.charged.mb**: Amount of memory, in MB, used as a unit of memory in the computation of quota utilization. If this is set to 1024 and a container run for one tick using 2048MB of memory, the container will be charged for two resource utilization.
  
* **yarn.resourcemanager.quota.price.base.general**: The base price, in number of credits, for using a unit of resources during one tick for non-specialized resources (CPU, memory). Default 1.
  
* **yarn.resourcemanager.quota.price.base.gpu**: The base price, in number of credits, for using a unit of resources during one tick for GPUs resources. Default 2.

Variable pricing:
=================
On top of charging for quota utilization Hops-YARN provide a variable pricing system to incentivize people to not use the cluster at pick time:

* **yarn.resourcemanager.quota.multiplicator.threshold.general**: The minimum cluster utilization, as a float between 0 and 1, after which the price of resources start to be increased proportionally to the cluster utilization, for non-specialized resources (CPU, memory). Default 0.2.
  
* **yarn.resourcemanager.quota.multiplicator.threshold.gpu**: The minimum cluster utilization, as a float between 0 and 1, after which the price of resources start to be increased proportionally to the cluster utilization, for GPUs. Default 0.2.
  
* **yarn.resourcemanager.quota.multiplicator.increment.general**: The multiplicator by which to multiply the resource utilization in order to compute the new resource price for non-specialized resources (CPU, memory). If this is set to 2 the price for resources will increase by 2% when the cluster utilization increase by 1%. Default: 1.
  
* **yarn.resourcemanager.quota.multiplicator.increment.gpu**: The multiplicator by which to multiply the resource utilization in order to compute the new resource price for GPUs. If this is set to 2 the price for resources will increase by 2% when the cluster utilization increase by 1%. Default: 2.
  
* **yarn.resourcemanager.quota.multiplicator.interval**: Time, in milliseconds between two evaluations of the resource pricing. Default 1000.

Charging as it runs:
===================
Charging application when they finish running is not compatible with long-running streaming applications. The following options allow you to charge the application for the resources they have used so far, while they are running.

* **yarn.resourcemanager.quota.containers.log.checkpoints.enabled**: Should the checkpointing system be enabled? If the checkpointing system is disabled, application will only be charged for the resources they used when the containers finish running. This can cause problems for long running applications: impossible for the user to know how much quota they have used, resource price not adapting with time. Default true.
  
* **yarn.resourcemanager.quota.containers.log.checkpoints.period**: Period, in number of ticks, at which to establish a checkpoint for a container. If the period is set to 6 and a container is running for a long time, the user will be charged for this container every 6 ticks as long as the container run. Default, 6.
  
* **yarn.resourcemanager.quota.multiplicator.fixed.period**: Period, in number of checkpoints, during which the price of resources is fixed for a given application. If this value is set to 10 and an application start while the cluster resource price is 1 then the application will pay a price of one during its 10 first checkpoints. Once the 10th checkpoint is reached, the price will be set to the current cluster resources pricing and this new price will be applied for the 10 next checkpoints. Default 10.

Database load:
==============
The following option allows you to tune the load generated by the quota system on the database:

* **yarn.resourcemanager.quota.batch.time**: Time, in milliseconds, during which quota utilization updates are batched before to be committed to the database. Reducing this value allows the user to be informed faster of their quota utilization and reduce the amount of data needing to be recovered in case of resource manager crash. On the other hand, reducing this value increase the load on the database. Default 500.
  
* **yarn.resourcemanager.quota.batch.size**: Maximum size, in number of updates, of the batch of quota utilization updates. If this number of updates is reached before the batch time is reached the update will be persisted to the database immediately. Increasing this value decreases the load on the database but increases the computation time for each batch. Default: 100.
