=================
Recommended Setup
=================

We recommend either Ubuntu/Debian or CentOS/Redhat as operating system (OS), with the same OS on all machines. A typical deployment of Hops Hadoop uses

* DataNodes/NodeManagers: a set of commodity servers in a 12-24 SATA hard-disk JBOD setup;
* NameNodes/ResourceManagers/NDB-database-nodes/Hopsworks-app-server: a homogeneous set of commodity (blade) servers with good CPUs, a reasonable amount of RAM, and one or two hard-disks;
* MySQL Cluster Data nodes: a homogeneous set of commodity (blade) servers with a good amount of RAM (up to 1 TB) and good CPU(s). A good quality SATA disk is needed to store database logs. We also recommend at lest 1 NVMe disk to store small files in HopsFS. These can be added later when more capacity for small files is needed.
* Hopsworks: a single commodity (blade) server with a good amount of RAM (up to 512 GB) and good CPU(s). A good quality disk is needed to store logs. Either SATA or a large SSD can be used.

For cloud platforms, such as AWS, we recommend using enhanced networking (25 Gb+) for the MySQL Cluster Data Nodes and the NameNodes/ResourceManagers. High latency connections between these machines will negatively affect system throughput.
