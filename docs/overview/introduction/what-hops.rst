===========================
What is Hops?
===========================


Hops is a next-generation cloud-native distribution of Apache Hadoop with full support for X.509 certificates for all services.
HopsFS is a `scaleout metadata file system <https://www.logicalclocks.com/blog/scalable-metadata-the-new-breed-of-file-systems-empowering-big-data-companies>`_ that has a Hadoop Filesystem (HDFS) compatible API.

.. figure:: ../../imgs/hopsfs-arch.png
   :alt: HopsFS Architecture
   :scale: 100
   :figclass: align-center

   HopsFS Architeture.

HopsFS replaces HDFS's Active-Standby Replication architecture with a set of stateless (redundant) NameNodes backed by an in-memory, shared nothing NewSQL database. HopsFS provides the DAL-API as an abstraction layer over the database, and implements a leader election protocol using the database. This means HopsFS no longer needs the following services required by Apache HDFS: quorum journal nodes, Zookeeper, and the Snapshot server.

.. _Apache Hadoop: http://hadoop.apache.org/releases.html


You can read more about HopsFS in this `HopsFS paper`_.

.. _HopsFS paper: https://www.usenix.org/conference/fast17/technical-sessions/presentation/niazi

