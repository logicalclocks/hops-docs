*************
Hops Overview
*************

  

Audience
********

This document contains four different guides: installation, user, administration, and developer guides. For the following different types of readers, we recommend reading the guides:

* Data Scientists

  * User Guide
  
* Hadoop Administrators

  * Installation Guide
  * Administration Guide
  
* Data Curators

  * User Guide

* Hops Developers

  * Installation Guide 
  * User Guide 
  * Developer Guide  

    
Revision History
*****************

    .. csv-table:: 
       :header: "Date", "Release", "Description"
       :widths: 10, 10, 30


       "Nov 2015", "2.4.0", "First release of Hops Documentation."

.. raw:: latex

    \newpage

What is Hops?
**********************       

Hops is a next-generation distribution of Apache Hadoop that supports:

* Hadoop-as-a-Service,
* Project-Based Multi-Tenancy,
* Secure sharing of DataSets across projects,
* Extensible metadata that supports free-text search using Elasticsearch,
* YARN quotas for projects.    

The key innovation that enables these features is a new architecture for scale-out, consistent metadata for both the Hadoop Filesystem (HDFS) and YARN (Hadoop's Resource Manager). The new metadata layer enables us to support multiple stateless NameNodes and TBs of metadata stored in MySQL Clustepr Network Database (NDB). NDB is a distributed, relational, in-memory, open-source database. This enabled us to provide services such as tools for designing extended metadata (whose integrity with filesystem data is ensured through foreign keys in the database), and also extending HDFS' metadata to enable new features such as erasure-coded replication, reducing storage requirements by 50\% compared to triple replication in Apache HDFS. Extended metadata has enabled us to implement quota-based scheduling for YARN, where projects can be given quotas of CPU hours/minutes and memory, thus enabling resource usage in Hadoop-as-a-Service to be accounted and enforced.

Hops builds on YARN to provide support for application and resource management. All YARN frameworks can run on Hops, but currently we only provide UI support for general data-parallel processing frameworks such as Apache Spark, Apache Flink, and MapReduce. We also support frameworks used by BiobankCloud for data-parallel bioinformatics workflows, including SAASFEE and Adam. In future, other frameworks will be added to the mix.


HopsWorks
*********

HopsWorks is the UI front-end to Hops. It supports user authentication through either a native solution, LDAP, or two-factor authentication. There are both user and adminstrator views for HopsWorks.
HopsWorks implements a perimeter security model, where command-line access to Hadoop services is restricted, and all jobs and interactive analyses are run from the HopsWorks UI and Apache Zeppelin (an iPython notebook style web application).

HopsWorks provides first-class support for DataSets and Projects. Each DataSet has a home project. Each project has a number of default DataSets:

-  *Resources*: contains programs and small amounts of data
-  *Logs*: contains outputs (stdout, stderr) for YARN applications


HopsWorks implements dynamic role-based access control for projects. That is, users do not have static global privileges. A user's privileges depend on what the user's active project is. For example, the user may be a *Data Owner* in one project, but only a *Data Scientist* in another project. Depending on which project is active, the user may be a *Data Owner* or a *Data Scientist*.
   
.. figure:: imgs/dynamic_roles.png
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
  * An optional 2nd factor can optionally be enabled for authentication. Supported devices are smartphones (Android, Apple, Windows) or Yubikey usb sticks.

  
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

* Apache Zepplin: interactive analytics with for Spark, Flink, and other data parallel frameworks;
* YARN batch jobs: batch-based submission (including Spark, MapReduce, Flink, Adam, and SaasFee);

MetaData Management
-------------------

HopsWorks provides support for the design and entry of extended metadata for files and directorsy:

* design your own extended metadata using an intuitive UI;
* enter extended metadata using an intuitive UI.

Free-text search
----------------

HopsWorks integrates with Elasticsearch to provide free-text search for files/directories and their extended metadata:

* `Global free-text search` for projects and DataSets in the filesystem;  
* `Project-based free-text search` of all files and extended metadata within a project.

   
HopsFS
******

HopsFS is a new implementation of the the Hadoop Filesystem (HDFS) based on `Apache Hadoop`_ 2x, that supports multiple stateless NameNodes, where the metadata is stored in an in-memory distributed database (NDB). HopsFS enables NameNode metadata to be both customized and analyzed, because it can be easily accessed via SQL or the native API (NDB API).

.. figure:: imgs/hopsfs-arch.png
   :alt: HopsFS Architecture
   :scale: 100
   :figclass: align-center

   HopsFS Architeture.
	 
HopsFS replaces HDFS 2.x's Primary-Secondary Replication model with an in-memory, shared nothing database. HopsFS provides the DAL-API as an abstraction layer over the database, and implements a leader election protocol using the database. This means HopsFS no longer needs several services required by highly available Apache HDFS: quorum journal nodes, Zookeeper, and the Snapshot server.

.. _Apache Hadoop: http://hadoop.apache.org/releases.html


HopsYarn
********

HopsYARN introduces a new metadata layer for Apache YARN, where the cluster state is stored in a distributed, in-memory, transactional database. HopsYARN enables us to provide quotas for Projects, in terms of how many CPU minutes and memory are available for use by each project. Quota-based scheduling is built as a layer on top of the capacity scheduler, enabling us to retain the benefits of the capacity scheduler.

.. figure:: ./imgs/hops-yarn.png
   :alt: Hops-YARN Architecture
   :scale: 75
   :width: 600
   :height: 400
   :figclass: align-center

   Hops YARN Architecture.
	      
**Apache Spark**
We support Apache Spark for both interactive analytics and jobs.

**Apache Zeppelin**
Apache Zeppelin is built-in to HopsWorks.
We have extended Zeppelin with access control, ensuring only users in the same project can access and share the same Zeppelin notebooks. We will soon provide source-code control for notebooks using GitHub.

**Apache Flink Streaming**
Apache Flink provides a dataflow processing model and is highly suitable for stream processing. We support it in HopsWorks.

**Other Services**
HopsWorks is a web application that runs on a highly secure Glassfish server. ElasticSearch is used to provide free-text search services. MySQL


BiobankCloud
********************

BiobankCloud extends HopsWorks with platform-specific support for Biobanking and Bioinformatics.
These services are:

* An audit log for user actions;
* Project roles compliant with the draft European General Data Protection Regulation;
* Consent form management for projects (studies);
* Charon, a service for securely sharing data between clusters using public clouds;
* SaasFee (cuneiform), a YARN-based application for building scalable bioinformatics pipelines.


..  .. figure:: imgs/biobankcloud-actors.png
..   :alt: Actors in a BiobankCloud Ecosystem within the context of the EU GPDR.
..   :scale: 75
..   :figclass: align-center

..   BiobankCloud Actors.
