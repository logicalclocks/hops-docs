==========================================================
Cloud Platforms (AWS, GCP, Azure)
==========================================================

Hops can be installed on a cloud platform using a AMI (for AWS), a GCP image or more flexibly using Karamel and Chef Solo.

Quickstart on AWS 
-------------------------------------

You can use Hopsworks.ai_ as a managed platform on AWS at:


.. _Hopsworks.ai: https://www.hopsworks.ai

   

Quickstart on AWS and GCP (Single-Host Installation)
-----------------------------------------------------

First, you need to create a virtual machine on AWS EC2 or GCP Compute Engine where Hopsworks will be installed (Centos/RHEL 7.x and Ubuntu 18.04 are supported). Then, from the account with sudo access, download and run the following script that installs Hopsworks:

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/master/hopsworks-installer.sh
   chmod +x hopsworks-installer.sh
   ./hopsworks-installer.sh

The above script will download and install Karamel on the same server that runs the script. Installation takes roughly 1 hr. To find out more about Karamel, read more below.



Quickstart on AWS and GCP (Multi-Host Installation)
-----------------------------------------------------

First, you need to create the virtual machines on AWS EC2 or GCP Compute Engine where Hopsworks will be installed (Centos/RHEL 7.x and Ubuntu 18.04 are supported). You pick one VM as the head node and on the account on that server with sudo access, you need to setup password ssh access to all the worker nodes.


Password-less SSH Access from the Head node to Worker nodes
==============================================================

First, on the head node, you should create an openssh keypair without a password:

.. code-block:: bash

   cat /dev/zero | ssh-keygen -q -N "" 
   cat ~/.ssh/id_rsa.pub

The second line above will print the public key for the sudo account on the head node. Copy that public key, and add it to the authorized_keys for all worker nodes, so that that the sudo account on the head node can SSH into the worker nodes without a password. If you have a custom image, you may need to configure your sshd daemon (sshd_config_ and sshlogin_) to allow openssh-key based login.

.. _sshlogin: https://www.cyberciti.biz/faq/ubuntu-18-04-setup-ssh-public-key-authentication/

.. _sshd_config: https://linuxize.com/post/how-to-setup-passwordless-ssh-login/

For GCP, you can edit the "VM Instance Details" and add the SSH key of the head node to all worker nodes. Alternatively, for both Ubuntu and Centos/RHEL, and assuming the sudo account is 'ubuntu' and our three worker nodes have hostnames 'vm1', 'vm2', and 'vm3', then you could run the following:

.. code-block:: bash

   ssh-copy-id -i $HOME/.ssh/id_rsa.pub ubuntu@vm1
   ssh-copy-id -i $HOME/.ssh/id_rsa.pub ubuntu@vm2
   ssh-copy-id -i $HOME/.ssh/id_rsa.pub ubuntu@vm3

Test that you now have passwordless SSH acess to all the worker nodes from the head node (assuming 'ubuntu' is the sudo account):

.. code-block:: bash

   ssh ubuntu@vm1
   ssh ubuntu@vm2
   ssh ubuntu@vm3



Multi-node installation
============================


On the head node, in the sudo account, download and run this script that installs Hopsworks on all hosts. It will ask you to enter the IP address of all the workers during installation:

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/master/hopsworks-installer.sh
   chmod +x hopsworks-installer.sh
   ./hopsworks-installer.sh

The above script will download and install Karamel on the same server that runs the script. Karamel will install Hopsworks across all hosts. Installation takes roughly 1 hr, slightly longer for large clusters. To find out more about Karamel, read more below.




Quickstart on Azure 
-------------------------------------

Azure VMs do not support private DNS by default, so you will need to add support for a private DNS space to the VMs used in Hopsworks. Follow these instructions AzureDNS_ to create the virtual machines for use in Hopsworks - but make sure your DNS zone name is very short, line 2-3 chars in length. If it is longer, you total fully qualified domain name might exceed 60 chars, and it will not work with OpenSSL/TLS. Once VMs have been created with a short private DNS name, you can follow the instructions above for single-host and multi-host installations for AWS and GCP.

.. _AzureDNS: https://docs.microsoft.com/en-us/azure/dns/private-dns-getstarted-portal


Karamel-based Installation
-------------------------------------

#. Download and install Karamel (http://www.karamel.io).
#. Run Karamel.
#. Click on the "Load Cluster Definition" menu item in Karamel. You are now prompted to select a cluster definition YAML file. Go to the examples/stable directory, and select a cluster definition file for your target cloud platform for one of the following cluster types:

   #. Amazon Web Services EC2 (AWS)
   #. Google Compute Engine (GCE)
   #. OpenStack
   #. On-premises (bare metal)

Example cluster definitions can be found at: https://github.com/logicalclocks/karamel-chef/tree/master/cluster-defns.
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
