******************
Hops Overview
******************

HopsFS is a new implementation of the the Hadoop Filesystem (HDFS) based on `Apache Hadoop`_ 2.0.4-alpha, that supports multiple stateless NameNodes, where the metadata is stored in an in-memory distributed database (MySQL Cluster). HopsFS enables more scalable clusters than Apache HDFS (up to ten times larger clusters), and enables NameNode metadata to be both customized and analyzed, because it can now be easily accessed via a SQL API.

.. figure:: imgs/hopsfs-arch.png
   :alt: HopsFS vs Apache HDFS Architecture

We have replaced HDFS 2.x's Primary-Secondary Replication model with shared atomic transactional memory. This means that we no longer use the parameters in HDFS that are based on the (eventually consistent) replication of edit log entries from the Primary NameNode to the Secondary NameNode using a set of quorum-based replication servers. Similarly, HopsFS, does not uses ZooKeeper and implements leader election and membership service using the transactional shared memory.

.. _Apache Hadoop: http://hadoop.apache.org/releases.html
