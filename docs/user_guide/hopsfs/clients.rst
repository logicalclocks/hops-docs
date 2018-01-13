.. _hopsfs-clients:

===========================
HopsFS Clients
===========================

For load balancing the clients uniformly distributes the filesystem operations among all the NameNodes in the system. HopsFS clients support ``RANDOM``, ``ROUND_ROBIN``, and ``RANDOM_STICKY`` policies to distribute the filesystem operations among the NameNodes. Random and round-robin policies are self explanatory. Using sticky policy the filesystem client randomly picks a NameNode and forwards all subsequent operation to the same NameNode. If the NameNode fails then the clients randomly picks another NameNode. This maximizes the NameNode cache hits.

In HDFS the client connects to the ``fs.defaultFS`` NameNode. In HopsFS, clients obtain the list of active NameNodes from the NameNode defined using ``fs.defaultFS`` parameter. The client then uniformly distributes the subsequent filesystem operations among the list of NameNodes.

In ``core-site.xml`` we have introduced a new parameter ``dfs.namenodes.rpc.addresses`` that holds the rpc address of all the NameNodes in the system. If the NameNode pointed by ``fs.defaultFS`` is dead then the client tries to connect to a NameNode defined by the ``dfs.namenodes.rpc.addresses``. As long as the NameNode addresses defined by the two parameters contain at least one valid address the client is able to communicate with the HopsFS. A detailed description of all the new client configuration parameters are :ref:`here<client-conf-parameters>`.



==========================
HopsFS Client API
==========================

FileSystem fs = FileSystem.get(new Configuration());

