.. _yarn_clients:
===========================
YARN Clients
===========================

Hops-YARN is fully compatible with Apache Hadoop YARN client. As in Apache Hadoop YARN the client have to be configured with the list of all possible scheduler to be able to find the leader one and start communicating with it.

When running Hops-YARN client it is possible to configure it to use the ConfiguredLeaderFailoverHAProxyProvider as a yarn.client.failover-proxy-provider. This will allow the client to find the leader faster than going through all the possible leaders present in the configuration file. This will also allow the client to find the leader even if it is not present in the client configuration file, as long as one of the resourceManager present in the client configuration file is alive.
