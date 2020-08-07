==========================================================
Installation in the Cloud
==========================================================

AWS 
===========

- :ref:`hopsworks-ai`
- :ref:`hopsworks-installer`.


Azure
===========

- :ref:`hopsworks-ai`
- :ref:`hopsworks-installer`;
- AZ CLI tools installation with :ref:`hopsworks-cloud-installer`.

GCP
===========

- :ref:`hopsworks-installer`.
- GCP CLI tools installation with :ref:`hopsworks-cloud-installer`.


.. _hopsworks-cloud-installer:

Hopsworks Cloud Installer
===============================

This installation requires the command-line on a  Linux machine (Ubuntu or Redhat/Centos). It will create the VMs on which Hopsworks will be installed using CLI tools (az or gcloud), and then install Hopsworks on those VMs. 


.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/2.0/hopsworks-cloud-installer.sh
   chmod +x hopsworks-cloud-installer.sh
   ./hopsworks-cloud-installer.sh
   
The above script will create the VMs using either the gcloud tools or azure tools. If the tools are not already installed, it will prompt for their installation. After the script has provisioned and configured the VMs, it will download both the :ref:`hopsworks-installer` script and the cluster definitions and call the :ref:`hopsworks-installer` script to install Hopsworks.

Example Installation Commands
-------------------------------------

The commands shown below can also be run non-interactively with the '-ni' switch.

.. code-block:: bash

   # Single-host Community Installation for GCP
   ./hopsworks-cloud-installer.sh -i community -c gcp
   # Single-host Community Installation for Azure
   ./hopsworks-cloud-installer.sh -i community -c azure


.. code-block:: bash

   # Multi-host Community Installation with 8 Nvidia V100 GPUs on a 8 VMs
   ./hopsworks-cloud-installer.sh -c gcp -i community-cluster -gt v100 --num-gpu-workers 8

   # Single-host Community Installation with 8 Nvidia P100 GPUs on one VM
   ./hopsworks-cloud-installer.sh -c gcp -i community-gpu -gt p100 -gpus 8


For the Enterprise installation, you will need to contact a Logical Clocks sales representative to acquire a URL, username, and password.

.. code-block:: bash

   # Single-host enterprise VM with 8 Nvidia GPUs using:
   ./hopsworks-cloud-installer.sh -c gcp -i enterprise -gt v100 -gpus 8 -d <URL> -du <username> -dp <password>


List at the running VMs:

.. code-block:: bash

   ./hopsworks-cloud-installer.sh -c azure -l
   

Customize your Cluster Installation
-------------------------------------

If you want to configure the Hopsworks cluster before installation (change the set of installed services, configure resources for services, configure username/passwords, etc), you can do so by first calling the script with the '--dry-run' switch. This will download the templates for the cluster definitions that will be used to install the head (master) VM and any worker VMs (with or without GPUs). More information on editing cluster definitions is in :ref:`hopsworks-cloud-installer`.

.. code-block:: bash

   # First download the cluster definitions by calling with '--dry-run'
   ./hopsworks-cloud-installer.sh --dry-run

   # Then edit the cluster definition(s) you want to change
   vim cluster-defns/hopsworks-head.yml
   vim cluster-defns/hopsworks-worker.yml   
   vim cluster-defns/hopsworks-worker-gpu.yml
		
   # Now run the installer script and it will install a cluster based on your updated cluster definitions
   ./hopsworks-cloud-installer.sh    

   
Installation Script Options
-------------------------------------

There are many command options that can be set when running the script. When the VM is created, it is given a name, that by defaul is prefixed by the Unix username. This VM name prefix can be changed using the '-n' argument. If you set your own prefix, you need to use it when listing and deleting VMs, passing the prefix for those listing and VM deletion commands ('-n <prefix> -rm'). If you have already created the VMs with the script but want to re-run the installation again on the existing VMs, you can pass the '-sc' argument that skips the creation of the VMs that Hopsworks will be installed on

.. code-block:: bash
		
  ./hopsworks-cloud-installer.sh -h
  usage: [sudo] ./
  [-h|--help]      help message
  [-i|--install-action community|community-gpu|community-cluster|enterprise|kubernetes]
  'community' installs Hopsworks Community on a single VM
  'community-gpu' installs Hopsworks Community on a single VM with GPU(s)
  'community-cluster' installs Hopsworks Community on a multi-VM cluster
  'enterprise' installs Hopsworks Enterprise (single VM or multi-VM)
  'kubernetes' installs Hopsworks Enterprise (single VM or multi-VM) alson with open-source Kubernetes
  'purge' removes any existing Hopsworks Cluster (single VM or multi-VM) and destroys its VMs
  [-c|--cloud gcp|aws|azure] Name of the public cloud
  [-dr|--dry-run]  generates cluster definition (YML) files, allowing customization of clusters.
  [-g|--num-gpu-workers num] Number of workers (with GPUs) to create for the cluster.
  [-gpus|--num-gpus-per-worker num] Number of GPUs per worker.
  [-gt|--gpu-type type]
  'v100' Nvidia Tesla V100
  'p100' Nvidia Tesla P100
  't4' Nvidia Tesla T4
  'k80' Nvidia K80
  [-d|--download-enterprise-url url] downloads enterprise binaries from this URL.
  [-dc|--download-url url] downloads binaries from this URL.
  [-du|--download-user username] Username for downloading enterprise binaries.
  [-dp|--download-password password] Password for downloading enterprise binaries.
  [-l|--list-public-ips] List the public ips of all VMs.
  [-n|--vm-name-prefix name] The prefix for the VM name created.
  [-ni|--non-interactive] skip license/terms acceptance and all confirmation screens.
  [-rm|--remove] Delete a VM - you will be prompted for the name of the VM to delete.
  [-sc|--skip-create] skip creating the VMs, use the existing VM(s) with the same vm_name(s).
  [-w|--num-cpu-workers num] Number of workers (CPU only) to create for the cluster.


.. _hopsworks-installer:

Installing Hopsworks on existing VMs
=========================================

The hopsworks-installer.sh script downloads, configures, and installs Hopsworks. It is typically run interactively, prompting the user about details of what to be is installed and where. It can also be run non-interactively (no user prompts) using the '-ni' switch.
   

AWS and GCP (Single-Host Installation)
-----------------------------------------

First, you need to create a virtual machine on AWS EC2 or GCP Compute Engine where Hopsworks will be installed (Centos/RHEL 7.x and Ubuntu 18.04 are supported). Then, from the account with sudo access, download and run the following script that installs Hopsworks:

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/1.3/hopsworks-installer.sh
   chmod +x hopsworks-installer.sh
   ./hopsworks-installer.sh

The above script will download and install Karamel on the same server that runs the script. Installation takes roughly 1 hr. To find out more about Karamel, read more below.



AWS and GCP (Multi-Host Installation)
-----------------------------------------

First, you need to create the virtual machines on AWS EC2 or GCP Compute Engine where Hopsworks will be installed (Centos/RHEL 7.x and Ubuntu 18.04 are supported). You pick one VM as the head node and on the account on that server with sudo access, you need to setup password ssh access to all the worker nodes.


Password-less SSH Access from the Head node to Worker nodes
-----------------------------------------------------------------

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
-----------------------------------


On the head node, in the sudo account, download and run this script that installs Hopsworks on all hosts. It will ask you to enter the IP address of all the workers during installation:

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/1.3/hopsworks-installer.sh
   chmod +x hopsworks-installer.sh
   ./hopsworks-installer.sh

The above script will download and install Karamel on the same server that runs the script. Karamel will install Hopsworks across all hosts. Installation takes roughly 1 hr, slightly longer for large clusters. To find out more about Karamel, read more below.


Installation Script Options
-----------------------------------

.. code-block:: bash
		
  ./hopsworks-installer.sh -h
  usage: [sudo] ./hopsworks-installer.sh
  [-h|--help]      help message
  [-i|--install-action localhost|localhost-tls|cluster|enterprise|karamel|purge|purge-all]
  'localhost' installs a localhost Hopsworks cluster
  'localhost-tls' installs a localhost Hopsworks cluster with TLS enabled
  'cluster' installs a multi-host Hopsworks cluster
  'enterprise' installs a multi-host Enterprise  Hopsworks cluster
  'kubernetes' installs a multi-host Enterprise Hopsworks cluster with Kubernetes
  'karamel' installs and starts Karamel
  'purge' removes Hopsworks completely from this host
  'purge-all' removes Hopsworks completely from ALL hosts
  [-cl|--clean]    removes the karamel installation
  [-dr|--dry-run]  does not run karamel, just generates YML file
  [-c|--cloud      on-premises|gcp|aws|azure]
  [-w|--workers    IP1,IP2,...,IPN|none] install on workers with IPs in supplied list (or none). Uses default mem/cpu/gpus for the workers.
  [-d|--download-enterprise-url url] downloads enterprise binaries from this URL.
  [-dc|--download-url] downloads binaries from this URL.
  [-du|--download-user username] Username for downloading enterprise binaries.
  [-dp|--download-password password] Password for downloading enterprise binaries.
  [-ni|--non-interactive)] skip license/terms acceptance and all confirmation screens.
  [-p|--https-proxy) url] URL of the https proxy server. Only https (not http_proxy) with valid certs supported.
  [-pwd|--password password] sudo password for user running chef recipes.
  [-y|--yml yaml_file] yaml file to run Karamel against.
  


Important Notes on Azure 
-----------------------

Azure VMs do not support private DNS by default, so you will need to add support for a private DNS space to the VMs used in Hopsworks. Follow these instructions AzureDNS_ to create the virtual machines for use in Hopsworks - but make sure your DNS zone name is very short (like 'hp' (2 chars)) and your VM name is short (like 'h1' (2 chars)). If it is longer, you total fully qualified domain name might exceed 60 chars, and it will not work with OpenSSL/TLS. An error message will appear during installation duing the kagent::install.rb recipe, like this:

FQDN h1.hops.io.5zchkifi2mmetn0a5saw0eu1me.ax.internal.cloudapp.net is too long! It should not be longer than 60 characters

Once VMs have been created with a short private DNS name, you can follow the instructions above for single-host and multi-host installations for AWS and GCP.

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
