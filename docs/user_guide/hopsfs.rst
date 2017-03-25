HopsFS User Guide
=================

.. toctree::
   :maxdepth: 1

   hopsfs/hdfs.rst
   hopsfs/namenodes.rst
   hopsfs/dataNodes.rst
   hopsfs/clients.rst
	 hopsfs/compatibility.rst
   hopsfs/quota-management.rst
   hopsfs/block.rst


HopsFS consist of the following types of nodes: NameNodes, DataNodes, and Clients. All the configurations parameters are defined in ``core-site.xml`` and ``hdfs-site.xml`` files.

Currently Hops only supports non-secure mode of operations. As Hops is a fork of the Hadoop code  base, most of the `Hadoop configuration parameters` and features are supported in Hops. In the following sections we highlight differences between HDFS and HopsFS and point out new configuration parameters and the parameters that are not supported due to different metadata management scheme .
