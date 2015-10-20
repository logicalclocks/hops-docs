
******************
System Requirements
******************


*Recommended Setup*

We recommend either Ubuntu/Debian or CentOS/Redhat as operating system (OS), with the same OS on all machines. A typical deployment of Hops Hadoop uses
* DataNodes/NodeManagers: a homogeneous set of commodity servers in a 12-24 SATA hard-disk JBOD setup;
* NameNodes/ResourceManagers/NDB-database-nodes/HopsWorks-app-server: a homogeneous set of commodity (blade) servers with good CPUs, a reasonable amount of RAM, and one or two hard-disks;
  
  

*Full Hops platform on a single machine*

You can run HopsWorks (and the entire Hops stack with ElasticSearch and NDB) on a single machine for development or testing purposes, but you will need at least:

==================   ================================
Component             Minimum Reqd        
==================   ================================
Operating System      Linux, Mac, Windows (using Virtualbox)
RAM                   8 GB of RAM
CPU                   2 GHz dual-core minimum. 64-bit.
Hard disk space       15 GB free space
Network               1 Gb Ethernet
==================   ================================

*DataNode & NodeManager*

A typical deployment of Hops Hadoop installs both the Hops DataNode and NodeManager on a homogeneous set of commodity servers, running without RAID (replication is done in software) in a 12-24 harddisk JBOD setup. Depending on your expected workloads, you can put as much RAM and CPU in the nodes as needed. Configurations can have up to (and probably more) than 512 GB RAM and 32 cores.

The recommended setup for these machines in production (on a cost-performance basis) is:

==================   ================================
Component             Recommended (late 2015)
==================   ================================
Operating System      Linux, Mac, Windows (using Virtualbox)
RAM                   128 GB RAM
CPU                   Two CPUs with 10 cores. 64-bit.
Hard disk             12 x 4 TB SATA disks
Network               1 Gb Ethernet
==================   ================================


*NameNode, ResourceManager, Database Nodes, App-server, ElasticSearch*

NameNodes, ResourceManagers, NDB database nodes, ElasticSearch, and the HopsWorks application server require relatively more memory and not as much hard-disk space as DataNodes. The machines can be blade servers with only a disk or two. SSDs will not give significant performance improvements to any of these services, except the HopsWorks application server if you copy a lot of data in and out of the cluster via HopsWorks. The  NDB database nodes will require free disk space that is at least 20 times the size of the RAM they use. Depending on how large your cluster is, the ElasticSearch server can be colocated with the HopsWorks application server or moved to its own machine with lower RAM and CPU requirements than the other services.

1 GbE gives great performance, but 10 GbE really makes it rock! You can deploy 10 GbE incrementally: first between the NameNodes/ResourceManagers <--> NDB database nodes to improve metadata processing performance, and then on the wider cluster. 

The recommended setup for these machines in production (on a cost-performance basis) is:

==================   ================================
Component             Recommended (late 2015)
==================   ================================
Operating System      Linux, Mac, Windows (using Virtualbox)
RAM                   128 GB RAM
CPU                   Two CPUs with 10 cores. 64-bit.
Hard disk             12 x 4 TB SATA disks
Network               1 Gb Ethernet
==================   ================================
