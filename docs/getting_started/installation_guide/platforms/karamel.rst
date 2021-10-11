.. _karamel-installer:

=======================
Karamel
=======================

#. Download and install `Karamel <http://www.karamel.io/>`_ 
#. Run Karamel.
#. Click on the "Load Cluster Definition" menu item in Karamel. You are now prompted to select a cluster definition YAML file.

Example cluster definitions can be found on `github <https://github.com/logicalclocks/karamel-chef/tree/2.4/cluster-defns>`_.


**Choosing which services to run on which nodes**

You need to decide which services you will install on which nodes. In Karamel, we design a set of *Node Groups*, where each *Node Group* defines a stack of services to be installed on a machine. Each machine will be a member of only one *Node Group*. Here are some recommended setups:

* a *single node cluster* that includes all services on a single node.
* a *tiny cluster* set of *heavy* stacks that includes a lot of services on each node.
* a *small cluster* set of *heavy* stacks that includes lots of services on each node.
* a *large cluster* set of *light* stacks that includes fewer services on each node.

**Single Node Setup**
You can run the entire Hopsworks application platform on a single node. You will have a NodeGroup with all of your services on the single node.

**Tiny Cluster Setup**

We recommend the following setup that includes the following NodeGroups, and requires at least 2 nodes to be deployed:

#. Hopsworks, MySQL Server, NDB Mgmt Server, HopsFS NameNode, YARN ResourceManager, NDB Data Node, Kafka, hopslog (ELK stack), hopsmonitor (prometheus)
#. HopsFS DataNode, YARN NodeManager

This is really only a test setup, but you will have one node dedicated to YARN applications and file storage, while the other node handles the metadata layer services.

**Small Cluster Setup**

We recommend the following setup that includes three NodeGroups:

#. Hopsworks, MySQL Server, NDB Mgmt Server, Kafka, hopslog (ELK stack), hopsmonitor (prometheus)
#. HopsFS NameNode, YARN ResourceManager, MySQL Server, NDB Data Node
#. HopsFS DataNode, YARN NodeManager

.. _ElasticHA: https://www.elastic.co/guide/en/elasticsearch/reference/master/high-availability.html
   
A highly available small cluster would require at least two instances of the above NodeGroups (with 3 NodeGroups, that means 6 instances in total). Note that Elasticsearch needs to be extra configuration if it is to be sharded across many instances, see Elasticsearch documentation for details (ElasticHA_).

**Large Cluster Setup**

We recommend the following setup that includes seven NodeGroups:

#. hopslog (ELK stack)
#. Kafka
#. Hopsworks, MySQL Server, NDB Mgmt Server, hopsmonitor (prometheus)
#. HopsFS NameNode, MySQL Server, 
#. YARN ResourceManager, MySQL Server
#. NDB Data Node
#. HopsFS DataNode, YARN NodeManager

A highly available large cluster would require at least two instances in every NodeGroup. Hopsworks can also be deployed on mulitple instances, while Elasticsearch needs to be specially configured if it is to be sharded across many insances. Otherwise, the other services can be easily scaled out by simply adding instances in Karamel. For improved performance, the metadata layer could be deployed on a better network (10 GbE at the time of writing), and the last NodeGroup (DataNode/NodeManager) instances could be deployed on cheaper network infrastructure (bonded 1 GbE  or 10 GbE, at the time of writing).


**Hopsworks Configuration in Karamel**

Karamel Chef recipes support a large number of parameters that can be set while installing Hops. These parameters include, but are not limited to,:

* usernames to install and run services as,
* usernames and passwords for services, and
* sizing and tuning configuration parameters for services (resources used, timeouts, etc).

Here are some of the most important security parameters to set when installing services:

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
