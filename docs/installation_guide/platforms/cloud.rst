=====================================
Cloud Platforms (AWS, GCE, OpenStack)
=====================================

.. contents:: Contents
   :local:
   :depth: 2

Hops can be installed on a cloud platform using Karamel/Chef.


Karamel/Chef
-------------------------------------

#. Download and install Karamel (http://www.karamel.io).
#. Run Karamel.
#. Click on the "Load Cluster Definition" menu item in Karamel. You are now prompted to select a cluster definition YAML file. Go to the examples/stable directory, and select a cluster definition file for your target cloud platform for one of the following cluster types:

   #. Amazon Web Services EC2 (AWS)
   #. Google Compute Engine (GCE)
   #. OpenStack
   #. On-premises (bare metal)

For more information on how to configure cloud-based installations, go to help documentation at http://www.karamel.io.
For on-premises installations, we provide some additional installation details and tips later in this section.


**Choosing which services to run on which nodes**

You now need to decide which services you will install on which nodes. In Karamel, we design a set of *Node Groups*, where each *Node Group* defines a stack of services to be installed on a machine. Each machine will only have one *Node Group* set of services.
We now provide two recommended setup:

* a *single node cluster* that includes all services on a single node.
* a *tiny cluster* set of *heavy* stacks that includes a lot of services on each node.
* a *small cluster* set of *heavy* stacks that includes lots of services on each node.
* a *large cluster* set of *light* stacks that includes fewer services on each node.

**Single Node Setup**
You can run the entire Hopsworks application platform on a single node. You will have a NodeGroup with the following services on the single node:

#. Hopsworks, Elasticsearch, MySQL Server, NDB Mgmt Server, HDFS NameNode, YARN ResourceManager, NDB Data Node(s), HDFS DataNode, YARN NodeManager


**Tiny Cluster Setup**

We recommend the following setup that includes the following NodeGroups, and requires at least 2 nodes to be deployed:

#. Hopsworks, Elasticsearch, MySQL Server, NDB Mgmt Server, HDFS NameNode, YARN ResourceManager, NDB Data Node
#. HDFS DataNode, YARN NodeManager

This is really only a test setup, but you will have one node dedicated to YARN applications and file storage, while the other node handles the metadata layer services.


**Small Cluster Setup**

We recommend the following setup that includes four NodeGroups, and requires at least 4 nodes to be deployed:

#. Hopsworks, Elasticsearch, MySQL Server, NDB Mgmt Server,
#. HDFS NameNode, YARN ResourceManager, MySQL Server
#. NDB Data Node
#. HDFS DataNode, YARN NodeManager

A highly available small cluster would require at least two instances of the last three NodeGroups. Hopsworks can also be deployed on mulitple instances, but Elasticsearch needs to be specially configured if it is to be sharded across many insances.

**Large Cluster Setup**

We recommend the following setup that includes six NodeGroups, and requires at least 4 nodes to be deployed:

#. Elasticsearch
#. Hopsworks, MySQL Server, NDB Mgmt Server
#. HDFS NameNode, MySQL Server
#. YARN ResourceManager, MySQL Server
#. NDB Data Node
#. HDFS DataNode, YARN NodeManager

A highly available large cluster would require at least two instances of every NodeGroup. Hopsworks can also be deployed on mulitple instances, while Elasticsearch needs to be specially configured if it is to be sharded across many insances. Otherwise, the other services can be easily scaled out by simply adding instances in Karamel. For improved performance, the metadata layer could be deployed on a better network (10 GbE at the time of writing), and the last NodeGroup (DataNode/NodeManager) instances could be deployed on cheaper network infrastructure (bonded 1 GbE  or 10 GbE, at the time of writing).


**Hopsworks Configuration in Karamel**

Karamel Chef recipes support a large number of parameters that can be set while installing Hops. These parameters include, but are not limited to,:

* usernames to install and run services as,
* usernames and passwords for services, and
* sizing and tuning configuration parameters for services (resources used, timeouts, etc).


Here are some of the most important security parameters to set when installing services:

- Superuser username and password for the MySQL Server(s)

  - Default: 'kthfs' and 'kthfs'
- Administration username and password for the Glassfish administration account(s)
      
  - Default: 'adminuser' and 'adminpw'
  
- Administration username and password for Hopsworks

  - Default: 'admin@hopsworks.ai' and 'admin'

Here are some of the most important sizing configuration parameters to set when installing services:

* DataMemory for NDB Data Nodes
* YARN NodeManager amount of memory and number of CPUs
* Heap size and Direct Memory for the NameNode
* Heap size for Glassfish
* Heap size for Elasticsearch
