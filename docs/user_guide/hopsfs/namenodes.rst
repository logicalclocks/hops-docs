===========================
NameNodes
===========================

.. contents:: Contents
   :local:
   :depth: 2

HopsFS supports multiple NameNodes. A NameNode is configured as if it is the only NameNode in the system. Using the database a NameNode discovers all the existing NameNodes in the system. One of the NameNodes is declared the leader for housekeeping and maintenance operations.  All the NameNodes in HopsFS are active. Secondary NameNode and Checkpoint Node configurations are not supported. See :ref:`section <Unsupported_Features>` for detail list of configuration parameters and features that are no longer supported in HopsFS.

For each NameNode define ``fs.defaultFS`` configuration parameter in the ``core-site.xml`` file. In order to load NDB driver set the ``dfs.storage.driver.*`` parameters in the ``hdfs-site.xml`` file. These parameter are defined in detail :ref:`here <loading_ndb_driver>`.

A detailed description of all the new configuration parameters for leader election, NameNode caches, distributed transaction handling, quota management, id generation and client configurations are defined :ref:`here<hopsFS_Configuration>`.

The NameNodes are started/stopped using the following commands (executed as HDFS superuser)::

    > $HADOOP_HOME/sbin/start-nn.sh

    > $HADOOP_HOME/sbin/stop-nn.sh

The Apache HDFS commands for starting/stopping NameNodes can also be used::

    > $HADOOP_HOME/sbin/hadoop-daemon.sh --script hdfs start namenode

    > $HADOOP_HOME/sbin/hadoop-daemon.sh --script hdfs stop namenode

Configuring HopsFS NameNode is very similar to configuring a HDFS NameNode. While configuring a single Hops NameNode, the configuration files are written as if it is the only NameNode in the system. The NameNode automatically detects other NameNodes using NDB.

Formating the Filesystem
------------------------

Running the format command on any NameNode **truncates** all the tables in the database and inserts default values in the tables. NDB atomically performs the **truncate** operation which can fail or take very long time to complete for very large tables. In such cases run the **/hdfs namenode -dropAndCreateDB** command first to drop and recreate the database schema followed by the **format** command to insert default values in the database tables. In NDB dropping and recreating a database is much quicker than truncating all the tables in the database.

NameNode Caches
---------------

In published Hadoop workloads, metadata accesses follow a heavy-tail distribution where 3% of files account for 80% of accesses. This means that caching recently accessed metadata at NameNodes could give a significant performance boost. Each NameNode has a local cache that stores INode objects for recently accessed files and directories. Usually, the clients read/write files in the same sub-directory. Using ``RANDOM_STICKY``  load balancing policy to distribute filesystem operations among the NameNodes lowers the latencies for filesystem operations as most of the path components are already available in the NameNode cache. See :ref:`HopsFS Client's <hopsfs-clients>` and :ref:`Cache Configuration Parameters <cache-parameters>` for more details.


Adding/Removing NameNodes
-------------------------

As the namenodes are stateless any NameNode can be removed with out effecting the state of the system. All on going operations that fail due to stopping the NameNode are automatically forwarded by the clients to the remaining namenodes in the system.

Similarly, the clients automatically discover the newly started namenodes. See :ref:`client configuration parameters <client-conf-parameters>` that determines how quickly a new NameNode starts receiving requests from the existing clients.
