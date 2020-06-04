==================================================
 Configuring Hops YARN fail-over and Distribution
==================================================

The main fail-over mechanism of Hops YARN is identical to the Apache Hadoop YARN fail-over mechanism and uses the same configuration as well. As a result, we invite you to have a look at the Apache Hadoop YARN configuration in order to set up your Hops YARN fail-over configuration.
Our modifications of the fail-over mechanism result in few new features and a limitation in the state store that can be used to store the cluster state:

Supported State Store:
======================
Since Hops YARN relies on the distributed database for the group membership management and its distributed model it was chosen not to support the existing state store to focus only on the database state store.

* **yarn.resourcemanager.store.class**: Should be set to ``org.apache.hadoop.yarn.server.resourcemanager.recovery.DBRMStateStore``


