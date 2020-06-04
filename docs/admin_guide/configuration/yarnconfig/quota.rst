==================================
Configuring Hops YARN quota system
==================================

To set a price for the different cluster resources and to charge applications in a fine-grained way, but without causing too much load on the resource manager and the database, several configuration parameters need to be tuned:

Basic parameters:
=================
This is the minimum configuration required to set up the quota system:

* **yarn.resourcemanager.quota.enabled**: Boolean value to enable or disable the quota system (default: false).

* **yarn.resourcemanager.quota.price.base.general**: The base price, in number of credits, for using a unit of resources during one second for non-specialized resources (CPU, memory). Default, ``1``.
  
* **yarn.resourcemanager.quota.price.base.gpu**: The base price, in number of credits, for using a unit of resources during one second for GPUs resources. Default, ``1``.

* **yarn.resourcemanager.quota.min.runtime**: The minimum amount of time (in milliseconds) for which a container will be charged. If a container runs for less than this time it will still be charged for this time. This is to put a price on the cluster resources that can't be allocated to other application while the container is being allocated and started. Default, ``10000 (10s)``.

* **yarn.resourcemanager.quota.minimum.charged.mb**: Amount of memory, in MB, used as a unit of memory in the computation of quota utilization. If this is set to ``1024`` and a container runs for one second using 2048MB of memory, the container will be charged for two resource utilizations.

* **yarn.resourcemanager.quota.minimum.charged.gpu**: Number of GPUs used as a unit in the computation of quota utilization. If this is set to ``1`` and a container runs for one second using 2 GPUs, the container will be charged for two resource utilizations.

* **yarn.resourcemanager.quota.scheduling.period**: Period (in ms) with which the resource manager computes the quota for the running containers. The shorter the period the less info is lost and the more accurate the quota in case of failover. But the shorter the period the more load is applied on the resource manager and the database.

* **yarn.resourcemanager.quota.multi-threaded-dispatcher.pool-size**: Size of the thread pool to handle quota events. Default 10.

Variable pricing:
=================
On top of charging for quota utilization, Hops YARN provides a variable pricing system to incentivize people to not use the cluster at pick time:

* **yarn.resourcemanager.quota.variable.price.enabled** boolean value to enable or disable the variable pricing system. Default: false.

* **yarn.resourcemanager.quota.multiplicator.interval**: Time (in ms) between two evaluation of the load on the cluster and computation of the pricing.

* **yarn.resourcemanager.quota.multiplicator.threshold.general**: The minimum cluster utilization, as a float between 0 and 1, after which the price of resources start to be increased proportionally to the cluster utilization, for non-specialized resources (CPU, memory). Default 0.2.
  
* **yarn.resourcemanager.quota.multiplicator.threshold.gpu**: The minimum cluster utilization, as a float between 0 and 1, after which the price of resources starts to increase proportionally to the cluster utilization, for GPUs. Default, ``0.2``.
  
* **yarn.resourcemanager.quota.multiplicator.increment.general**: The multiplicator by which to multiply the resource utilization to compute the new resource price for non-specialized resources (CPU, memory). If this is set to ``2``, the price for resources will increase by 2% when cluster utilization increases by 1%. Default, ``1``.
  
* **yarn.resourcemanager.quota.multiplicator.increment.gpu**: The multiplicator by which to multiply the resource utilization to compute the new resource price for GPUs. If this is set to ``2``, the price for resources will increase by 2% when the cluster utilization increases by 1%. Default, ``2``.
  
* **yarn.resourcemanager.quota.multiplicator.interval**: Time, in milliseconds between two evaluations of the resource pricing. Default, ``1000``.
