******************
Hops Overview
******************

Hops is a next-generation distribution of Apache Hadoop that supports Hadoop-as-a-Service, Project-Based Multi-Tenancy, secure sharing of DataSets across projects, and extensible and searchable metadata. The key innovation that enables these features is a new architecture for scale-out, consistent metadata for both the Hadoop Filesystem (HDFS) and YARN (Hadoop's resource manager). The new metadata layer enables us to support multiple stateless NameNodes and TBs of metadata to be stored in a distributed, relational, in-memory, open-source database, called NDB. This enabled us to provide services such as tools for designing extended metadata (whose integrity with filesystem data is ensured through foreign keys in the database), and also extending HDFS' metadata to enable new features such as erasure-coded replication, reducing storage requirements by 50\% compared to triple replication in Apache HDFS. Extended metadata has enabled us to implement quota-based scheduling for YARN, where projects can be given quotas of CPU hours/minutes and memory, thus enabling resource usage in Hadoop-as-a-Service to be accounted and enforced.

Hops uses YARN to manage applications and resource management. All YARN frameworks can potentially run on Hops, but currently we support general data-parallel processing frameworks such as Apache Spark, Apache Flink, and MapReduce. We also support frameworks used by BiobankCloud for data-parallel bioinformatics workflows, including SaasFee and Adam. In future, other frameworks will be added to the mix.


HopsWorks
==========
HopsWorks is the UI front-end to Hops. It supports user authentication through either a native solution, LDAP, or two-factor authentication. There are both user and adminstrator views for HopsWorks.
HopsWorks implements a perimeter security model, where command-line access to Hadoop services is restricted, and all jobs and interactive analyses are run from the HopsWorks UI and Apache Zeppelin (an iPython notebook style web application).


HopsWorks is the User Interface to the Hops platform. It provides support for:

* authentication, authorization, and auditing;
* project-based multi-tenancy with multiple roles;
* secure dataset sharing between projects;
* free-text search of metadata with ElasticSearch;
* interactive analytics with Apache Zepplin for Spark and Flink;
* batch-based YARN job submission (including Spark and Flink);
* extended metadata designer;
* fast dataset browsing and uploading.    

HopsWorks provides first-class support for DataSets and Projects.
Each DataSet has a home project. Each project has a number of default DataSets:

-  *Resources*: contains programs and small amounts of data
-  *Logs*: contains outputs (stdout, stderr) for YARN applications


HopsWorks implements dynamic role-based access control for projects. That is, users do not have static privileges. If a user is able to upload and download data to/from a project, the user can only do so within the context of that project. She cannot run a MapReduce job that reads from that project and copies data to another project, where the user also happens to have data import/export privileges.

.. figure:: imgs/dynamic_roles.eps
   :alt: Dynamic Roles ensures strong multi-tenancy in HopsWorks

We support two roles: Data Scientist and Data Owner.
A Data Scientist can

* run interactive analytics through Apache Zeppelin and YARN jobs (Spark, Flink, MR) that write output to the Logs DataSet for the project
*  only upload restricted data (programs and resources) to projects.


A Data Owner can

* upload/download data, 
* add and remove  members of the project
* change the role for project members
* create and delete DataSets
* import and export data from DataSets
* design and update metadata for files/directories/DataSets	 


The stack of services available through HopsWorks is:

.. figure:: imgs/hopsworks-stack.eps
   :alt: HopsWorks stack of services

      

BiobankCloud
===============

BiobankCloud extends HopsWorks with platform-specific support for Biobanking and Bioinformatics.

.. figure:: imgs/biobankcloud-actors.eps
   :alt: Actors in a BiobankCloud Ecosystem within the context of the EU GPDR.


HopsFS
======
HopsFS is a new implementation of the the Hadoop Filesystem (HDFS) based on `Apache Hadoop`_ 2.0.4-alpha, that supports multiple stateless NameNodes, where the metadata is stored in an in-memory distributed database (NDB). HopsFS enables more scalable clusters than Apache HDFS (up to ten times larger clusters), and enables NameNode metadata to be both customized and analyzed, because it can now be easily accessed via a SQL API.

.. figure:: imgs/hopsfs-arch.png
   :alt: HopsFS vs Apache HDFS Architecture

We have replaced HDFS 2.x's Primary-Secondary Replication model with shared atomic transactional memory. This means that we no longer use the parameters in HDFS that are based on the (eventually consistent) replication of edit log entries from the Primary NameNode to the Secondary NameNode using a set of quorum-based replication servers. Similarly, HopsFS, does not uses ZooKeeper and implements leader election and membership service using the transactional shared memory.

.. _Apache Hadoop: http://hadoop.apache.org/releases.html


Hops Yarn
=========

.. figure:: ./imgs/hops-yarn.png
   :alt: Hops-YARN Architecture
