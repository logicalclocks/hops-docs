.. _ndb-conf-parameters:

===========================
Data Access Layer (DAL)
===========================

.. contents:: Contents
   :local:
   :depth: 2

Using DAL layer HopsFS's metadata can be stored in different databases. HopsFS provides a driver to store the metadata in MySQL Cluster Network Database (NDB).

MySQL Cluster Network Database Driver Configuration
---------------------------------------------------


Database specific parameter are stored in a ``.properties`` file. The configuration files contains following parameters.

* **com.mysql.clusterj.connectstring**:
  Address of management server of MySQL NDB Cluster.

* **com.mysql.clusterj.database**:
  Name of the database schema that contains the metadata tables.

* **com.mysql.clusterj.connection.pool.size**:
  This is the number of connections that are created in the ClusterJ connection pool. If it is set to 1 then all the sessions share the same connection; all requests for a SessionFactory with the same connect string and database will share a single SessionFactory. A setting of 0 disables pooling; each request for a SessionFactory will receive its own unique SessionFactory.

* **com.mysql.clusterj.max.transactions**:
  Maximum number transactions that can be simultaneously executed using the clusterj client. The maximum support transactions are 1024.

* **io.hops.metadata.ndb.mysqlserver.host**
  Address of MySQL server. For higher performance we use MySQL Server to perform a aggregate queries on the file system metadata.

* **io.hops.metadata.ndb.mysqlserver.port**:
  If not specified then default value of 3306 will be used.

* **io.hops.metadata.ndb.mysqlserver.username**:
  A valid user name to access MySQL Server.

* **io.hops.metadata.ndb.mysqlserver.password**:
  MySQL Server user password

* **io.hops.metadata.ndb.mysqlserver.connection pool size**:
  Number of NDB connections used by the MySQL Server. The default is set to 10.

* **Database Sessions Pool**:
  For performance reasons the data access layer maintains a pools of pre-allocated ClusterJ session objects. Following parameters are used to control the behavior the session pool.

  - **io.hops.session.pool.size**:
    Defines the size of the session pool. The pool should be at least as big as the number of active transactions in the system. Number of active transactions in the system can be calculated as ( **dfs.datanode.handler.count** + **dfs.namenode.handler.count** + **dfs.namenode.subtree-executor-limit**).
  - **io.hops.session.reuse.count**:
    Session is used N times and then it is garbage collected. Note: Due to imporoved memory management in ClusterJ >= 7.4.7, N can be set to higher values i.e. Integer.MAX_VALUE for latest ClusterJ libraries.

.. _loading_ndb_driver:

Loading a DAL Driver
--------------------

In order to load a DAL driver following configuration parameters are added to ``hdfs-site.xml`` file.

* **dfs.storage.driver.jarFile**:
  path of driver jar file if the driver's jar file is not included in the class path.

* **dfs.storage.driver.class**:
  main class that initializes the driver.

* **dfs.storage.driver.configfile**:
  path to a file that contains configuration parameters for the driver jar file. The path is supplied to the **dfs.storage.driver.class** as an argument during initialization. See :ref:`hops ndb driver configuration parameters <ndb-conf-parameters>`.
