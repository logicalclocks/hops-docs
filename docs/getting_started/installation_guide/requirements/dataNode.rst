========================
DataNode and NodeManager
========================

A typical deployment of Hopsworks installs both the Hops DataNode and NodeManager on a set of commodity servers, running without RAID (replication is done in software) in a 12-24 hard-disk JBOD setup. Depending on your expected workloads, you can put as much RAM and CPU in the nodes as needed. Configurations can have up to (and probably more) than 1 TB RAM and 48 cores.

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
