.. _hopsworks-cloud-installer:

==========================================================
Hopsworks Cloud Installer
==========================================================

This installation requires the command-line on a  Linux machine (Ubuntu or Redhat/Centos). It will create the VMs on which Hopsworks will be installed using CLI tools (az or gcloud), and then install Hopsworks on those VMs. 


.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/2.2/cloud/hopsworks-cloud-installer.sh
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

If you want to configure the Hopsworks cluster before installation, you can do so by first calling the script with the '--dry-run' switch. This will download the templates for the cluster definitions that will be used to install the head (master) VM and any worker VMs (with or without GPUs). More information on editing cluster definitions is in :ref:`hopsworks-cloud-installer`.

.. code-block:: bash

   # First download the cluster definitions by calling with '--dry-run'
   ./hopsworks-cloud-installer.sh --dry-run

   # Then edit the cluster definition(s) you want to change
   vim cluster-defns/hopsworks-head.yml
   vim cluster-defns/hopsworks-worker.yml   
   vim cluster-defns/hopsworks-worker-gpu.yml
		
   # Now run the installer script and it will install a cluster based on your updated cluster definitions
   ./hopsworks-cloud-installer.sh    


Upgrades
-----------------------------------------------------------------

When you have completed an installation, a cluster definition file is stored on the head server in `cluster-defns/hopsworks-installation.yml` - relative to the path of `hopsworks-installer.sh`. Move this file to a safe location (it contains any passwords set for different services). The yml file is also needed to perform an upgrade of Hopsworks using: :ref:`karamel-installer`.

   
Installation Script Options
-------------------------------------

There are many command options that can be set when running the script. When the VM is created, it is given a name, that by default is prefixed by the Unix username. This VM name prefix can be changed using the '-n' argument. If you set your own prefix, you need to use it when listing and deleting VMs, passing the prefix for those listing and VM deletion commands ('-n <prefix> -rm'). If you have already created the VMs with the script but want to re-run the installation again on the existing VMs, you can pass the '-sc' argument that skips the creation of the VMs that Hopsworks will be installed on

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

