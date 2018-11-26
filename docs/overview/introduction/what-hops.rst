===========================
What is Hops?
===========================


Hops is a next-generation distribution of Apache Hadoop, with a heavily adapted impelementation of HDFS, called HopsFS.
HopsFS is a new implementation of the the Hadoop Filesystem (HDFS) based on `Apache Hadoop`_ 2.8, that supports multiple stateless NameNodes, where the metadata is stored in an in-memory distributed database (NDB). HopsFS enables NameNode metadata to be both customized and analyzed, because it can be easily accessed via SQL or the native API (NDB API).

.. figure:: ../../imgs/hopsfs-arch.png
   :alt: HopsFS Architecture
   :scale: 100
   :figclass: align-center

   HopsFS Architeture.

HopsFS replaces HDFS's Active-Standby Replication architecture with a set of stateless (redundant) NameNodes backed by an in-memory, shared nothing NewSQL database. HopsFS provides the DAL-API as an abstraction layer over the database, and implements a leader election protocol using the database. This means HopsFS no longer needs the following services required by Apache HDFS: quorum journal nodes, Zookeeper, and the Snapshot server.

.. _Apache Hadoop: http://hadoop.apache.org/releases.html


You can read more about HopsFS in this `HopsFS paper`_.

.. _HopsFS paper: https://www.usenix.org/conference/fast17/technical-sessions/presentation/niazi

