===========================
HopsFS Async Quota Management
===========================

In HopsFS the commands and the APIs for quota management are identical to HDFS. In HDFS all Quota management operations are performed synchronously while in HopsFS Quota management is performed asynchronously for performance reasons. In the following example maximum namespace quota for ``/QDir`` is set to 10. When a new sub-directory or a file is created in this folder then the quota update information propagates up the filesystem tree until it reaches ``/QDir``. Each quota update propagation operation is implemented as an independent transaction.

.. figure:: ../../imgs/quota-update.png
  :alt: HopsFS Quota Update
  :scale: 100
  :figclass: align-center

  HopsFS Quota Update

For write heavy workloads a user might be able to consume more diskspace/namespace than it is allowed before the filesystem recognizes that the quota limits have been violated. After the quota updates are applied the filesystem will not allow the use to further violate the quota limits. In most existing Hadoop clusters, write operations are a small fraction of the workload. Additionally, considering the size of the filesystem we think this is a small trade off for improving throughput for read operations that typically comprise 90-95% a typical filesystem workload.


In HopsFS asynchronous quota updates are highly optimized. We batch the quota updates wherever possible.  :ref:`In the linked section  <quota-parameters>` there is a complete list of parameters that determines how aggressively asynchronous quota updates are applied.
