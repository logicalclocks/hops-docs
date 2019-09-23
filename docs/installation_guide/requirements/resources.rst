======================================================================================
NameNode, ResourceManager, NDB Data Nodes, Hopsworks, Kafka, and ElasticSearch
======================================================================================

NameNodes, ResourceManagers, NDB database nodes, ElasticSearch, and the Hopsworks application server require relatively more memory and not as much hard-disk space as DataNodes. The machines can be blade servers with only a disk or two. SSDs will not give significant performance improvements to any of these services, except the Hopsworks application server if you copy a lot of data in and out of the cluster via Hopsworks. The  NDB database nodes will require free disk space that is at least 20 times the size of the RAM they use. Depending on how large your cluster is, the ElasticSearch server and Kafka brokers can be colocated with the Hopsworks application server or moved to its own machine with lower RAM and CPU requirements than the other services.

1 GbE gives great performance, but 10 GbE really makes it rock! You can deploy 10 GbE incrementally: first between the NameNodes/ResourceManagers <--> NDB database nodes to improve metadata processing performance, and then on the wider cluster.

The recommended setup for these machines in production (on a cost-performance basis) is:

.. tabularcolumns:: {| p{\dimexpr 0.3\linewidth-2\tabcolsep} | p{\dimexpr 0.7\linewidth-2\tabcolsep}|}

==================   ================================
**Component**        **Recommended (2018)**
==================   ================================
Operating System      Linux, Mac, Windows (using Virtualbox)
RAM                   256 GB RAM
CPU                   Two CPUs with at least 12 cores. 64-bit.
Hard disk             12 x 10 TB SATA disks
Network               10/25 Gb/s Ethernet
==================   ================================
