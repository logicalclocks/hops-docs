===========================
DataNodes
===========================

The DataNodes periodically acquire an updated list of NameNodes in the system and establish a connection (register) with the new NameNodes. Like clients, the DataNodes also uniformly distribute the filesystem operations among all the NameNodes in the system. Currently the DataNodes only support round-robin policy to distribute the filesystem operations.

HopsFS DataNodes configuration is identical to HDFS DataNodes. In HopsFS a DataNode connects to all the NameNodes. Make sure that the ``fs.defaultFS`` parameter points to valid NameNode in the system. The DataNode will connect to the NameNode and obtain a list of all the active NameNodes in the system, and then connects/registers with all the NameNodes in the system.

The DataNodes can started/stopped using the following commands (executed as HDFS superuser)::

   > $HADOOP_HOME/sbin/start-dn.sh

   > $HADOOP_HOME/sbin/stop-dn.sh

The Apache HDFS commands for starting/stopping Data Nodes can also be used::

   > $HADOOP_HOME/sbin/hadoop-deamon.sh --script hdfs start datanode

   > $HADOOP_HOME/sbin/hadoop-deamon.sh --script hdfs stop datanode
