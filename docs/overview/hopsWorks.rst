===========================
HopsWorks
===========================

.. contents:: Contents
  :local:
  :depth: 2

HopsWorks is the UI front-end to Hops. It supports user authentication through either a native solution, LDAP, or two-factor authentication. There are both user and adminstrator views for HopsWorks.
HopsWorks implements a perimeter security model, where command-line access to Hadoop services is restricted, and all jobs and interactive analyses are run from the HopsWorks UI and Apache Zeppelin (an iPython notebook style web application).

HopsWorks provides first-class support for DataSets and Projects. Each DataSet has a home project. Each project has a number of default DataSets:

-  *Resources*: contains programs and small amounts of data
-  *Logs*: contains outputs (stdout, stderr) for YARN applications
-  *notenook*: contains Apache Zeppelin saved notebooks along with
   their configuration


HopsWorks implements dynamic role-based access control for projects. That is, users do not have static global privileges. A user's privileges depend on what the user's active project is. For example, the user may be a *Data Owner* in one project, but only a *Data Scientist* in another project. Depending on which project is active, the user may be a *Data Owner* or a *Data Scientist*.

.. figure:: ../imgs/dynamic_roles.png
  :alt: Dynamic Roles ensures strong multi-tenancy in HopsWorks
  :scale: 60
  :figclass: align-center

  Dynamic Roles ensures strong multi-tenancy between projects in HopsWorks.

The following roles are supported:

**A Data Scientist can**

* run interactive analytics through Apache Zeppelin
* run batch jobs (Spark, Flink, MR)
* upload to a restricted DataSet (called *Resources*) that contains only programs and resources

**A Data Owner can**

* upload/download data to the project,
* add and remove members of the project
* change the role of project members
* create and delete DataSets
* import and export data from DataSets
* design and update metadata for files/directories/DataSets


..  HopsWorks is built on a number of services, illustrated below:
..  HopsWorks Layered Architecture.


HopsWorks covers: users, projects and datasets, analytics, metadata mangement and free-text search.

Users
-----

* Users authenticate with a valid email address
  * A 2nd factor can optionally be enabled for
  authentication. Supported devices are smartphones (Android, Apple,
  Windows) with an one-time password generator such as `Google Authenticator`_.


.. _Google Authenticator: https://support.google.com/accounts/answer/1066447?hl=en

Projects and DataSets
---------------------

HopsWorks provides the following features:

* project-based multi-tenancy with dynamic roles;
* CPU hour quotas for projects (supported by HopsYARN);
* the ability to share DataSets securely between projects (reuse of DataSets without copying);
* DataSet browser;
* import/export of data using the Browser.

Analytics
---------

HopsWorks provides two services for executing applications on YARN:

* Apache Zepplin: interactive analytics for Spark, Flink, and other data parallel frameworks;
* YARN batch jobs: batch-based submission (including Spark, MapReduce, Flink, Adam, and SaasFee);

MetaData Management
-------------------

HopsWorks provides support for the design and entry of extended metadata for files and directories:

* design your own extended metadata using an intuitive UI;
* enter extended metadata using an intuitive UI.

Free-text search
----------------

HopsWorks integrates with Elasticsearch to provide free-text search for files/directories and their extended metadata:

* `Global free-text search` for projects and DataSets in the filesystem;
* `Project-based free-text search` of all files and extended metadata within a project.


Logs aggregation
----------------

HopsWorks provides Logstash/Kibana-as-a-Service for logs aggregation
and visualization.

Spark metrics
-------------

Monitor and debug your Spark applications with our Graphite/Graphana
solution for real-time metrics visualization.
