.. _yarn_node_manager:

===========================
YARN NodeManager
===========================

In non distributed mode the NodeManagers should be configured to use ConfiguredLeaderFailoverHAProxyProvider as a failover proxy provider. This allows them to automatically find the leading ResourceManager and to connect to it.

In distributed mode the NodeManagers should be configured to use ConfiguredLeastLoadedRMFailoverHAProxyProvider as a failover proxy provider. This allows them to automatically find the resourceTracker which is the least loaded and to connect to it.

.. _configuration: https://hadoop.apache.org/docs/r2.4.1/hadoop-yarn/hadoop-yarn-common/yarn-default.xml
.. _service: http://link.springer.com/chapter/10.1007%2F978-3-319-19129-4_13
