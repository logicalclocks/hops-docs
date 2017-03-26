.. _client-conf-parameters:

===========================
Client Configurations
===========================

All the client configuration parameters are defined in ``core-site.xml`` file.

* **dfs.namenodes.rpc.addresses**:
  HopsFS support multiple active NameNodes. A client can send a RPC request to any of the active NameNodes. This parameter specifies a list of active NameNodes in the system. The list has following format [hdfs://ip:port, hdfs://ip:port, ...]. It is not necessary that this list contain all the active NameNodes in the system. Single valid reference to an active NameNode is sufficient. At the time of startup the client obtains an updated list of NameNodes from a NameNode mentioned in the list. If this list is empty then the client tries to connect to **fs.default.name**.

* **dfs.namenode.selector-policy**:
  The clients uniformly distribute the RPC calls among the all the NameNodes in the system based on the following policies.
  - ROUND ROBIN
  - RANDOM
  - RANDOM_STICKY
  By default NameNode selection policy is set to RANDOM_STICKY

* **dfs.clinet.max.retires.on.failure**:
  The client retries the RPC call if the RPC fails due to the failure of the NameNode. This configuration parameter specifies how many times the client would retry the RPC before throwing an exception. This property is directly related to number of expected simultaneous failures of NameNodes. Set this value to 1 in case of low failure rates such as one dead NameNode at any given time. It is recommended that this property must be set to value >= 1.
* **dfs.client.max.random.wait.on.retry**:
  A RPC can fail because of many factors such as NameNode failure, network congestion etc. Changes in the membership of NameNodes can lead to contention on the remaining NameNodes. In order to avoid contention on the remaining NameNodes in the system the client would randomly wait between [0,MAX VALUE] ms before retrying the RPC. This property specifies MAX VALUE; by default it is set to 1000 ms.
* **dfs.client.refresh.namenode.list**:
  All clients periodically refresh their view of active NameNodes in the system. By default after every minute the client checks for changes in the membership of the NameNodes. Higher values can be chosen for scenarios where the membership does not change frequently.
