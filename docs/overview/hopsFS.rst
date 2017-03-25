===========================
HopsFS
===========================


HopsFS is a new implementation of the the Hadoop Filesystem (HDFS) based on `Apache Hadoop`_ 2.x, that supports multiple stateless NameNodes, where the metadata is stored in an in-memory distributed database (NDB). HopsFS enables NameNode metadata to be both customized and analyzed, because it can be easily accessed via SQL or the native API (NDB API).

.. figure:: ../imgs/hopsfs-arch.png
   :alt: HopsFS Architecture
   :scale: 100
   :figclass: align-center

   HopsFS Architeture.

HopsFS replaces HDFS 2.x's Primary-Secondary Replication model with an in-memory, shared nothing database. HopsFS provides the DAL-API as an abstraction layer over the database, and implements a leader election protocol using the database. This means HopsFS no longer needs several services required by highly available Apache HDFS: quorum journal nodes, Zookeeper, and the Snapshot server.

.. _Apache Hadoop: http://hadoop.apache.org/releases.html
