.. _hopsworks-installer:

Hopsworks Installer
=========================================

The hopsworks-installer.sh script downloads, configures, and installs Hopsworks. It is typically run interactively, prompting the user about details of what to be is installed and where. It can also be run non-interactively (no user prompts) using the '-ni' switch.
   

Requirements
-----------------------------------
You need at least one server or virtual machine on which Hopsworks will be installed with at least the following specification:

* Centos/RHEL 7.x or Ubuntu 18.04;
* at least 32GB RAM,
* at least 8 CPUs,
* 100 GB of free hard-disk space,
* outside Internet access (if this server is air-gapped, contact Logical Clocks for support),
* a UNIX user account with sudo privileges.


Quickstart 
-----------------------------------------

On your server/VM, run the following bash commands from your user account with sudo privileges:

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/1.4/hopsworks-installer.sh
   chmod +x hopsworks-installer.sh
   ./hopsworks-installer.sh

   Installation takes roughly 1 hr, or slower if your server/VM has a low-bandwidth Internet connection.

   Once your cluster is up and runnin, you can stop (and start) Hopsworks using the commands:
   
.. code-block:: bash

   sudo /srv/hops/kagent/kagent/bin/shutdown-all-local-services.sh
   sudo /srv/hops/kagent/kagent/bin/start-all-local-services.sh

   Note that all services in Hopsworks are systemd services that are enabled by default, that is, they will restart when VM/server is rebooted. 

Setting up a Cluster for Installation
-----------------------------------------------------------------

You need to identify a set of servers/VMs and create the same user account with sudo privileges on all the servers. You should identify one server as the head server from which you will perform the installation. You need to ensure that the nodes can communicate with each other on every port and to configure password-less SSH Access from the Head node to Worker nodes. First, on the head node, you should create an openssh keypair without a password:

.. code-block:: bash

   cat /dev/zero | ssh-keygen -q -N "" 
   cat ~/.ssh/id_rsa.pub

The second line above will print the public key for the sudo account on the head node. Copy that public key, and append it to the ~/.ssh/authorized_keys files on all worker nodes, so that that the sudo account on the head node can SSH into the worker nodes without a password. It may be that you need to configure your sshd daemon (sshd_config_ and sshlogin_) to allow openssh-key based login, depending on how your server is configured:

.. _sshlogin: https://www.cyberciti.biz/faq/ubuntu-18-04-setup-ssh-public-key-authentication/

.. _sshd_config: https://linuxize.com/post/how-to-setup-passwordless-ssh-login/

For both Ubuntu and Centos/RHEL, and assuming the sudo account is 'ubuntu' and our three worker nodes have hostnames 'vm1', 'vm2', and 'vm3', then you could run the following:

.. code-block:: bash

   ssh-copy-id -i $HOME/.ssh/id_rsa.pub ubuntu@vm1
   ssh-copy-id -i $HOME/.ssh/id_rsa.pub ubuntu@vm2
   ssh-copy-id -i $HOME/.ssh/id_rsa.pub ubuntu@vm3

Test that you now have passwordless SSH acess to all the worker nodes from the head node (assuming 'ubuntu' is the sudo account):

.. code-block:: bash

   # from the head VM
   ssh ubuntu@vm1
   ssh ubuntu@vm2
   ssh ubuntu@vm3



Multi-node installation
-----------------------------------


On the head node, in the sudo account, download and run this script that installs Hopsworks on all hosts. It will ask you to enter the IP address of all the workers during installation:

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/1.4/hopsworks-installer.sh
   chmod +x hopsworks-installer.sh
   ./hopsworks-installer.sh

The above script will download and install Karamel on the same server that runs the script. Karamel will install Hopsworks across all hosts. Installation takes roughly 1 hr, slightly longer for large clusters. To find out more about Karamel, read more below.


Purge an Existing Cluster Installation
-----------------------------------------------------------------

.. code-block:: bash

   ./hopsworks-installer.sh -i purge -ni



Installation from behind a HTPP Proxy (firewall)
---------------------------------------------------

Installation will not work if your http proxy has a self-signed certificate.
You can explictly specify the http proxy by passing the '-p' switch to the installer.

.. code-block:: bash

   ./hopsworks-installer.sh -p https://1.2.3.4:3283

If you have set the environment variable http_proxy or https_proxy, hopsworks-installer.sh will use it, even if you don't specify the '-p-' switch. The '-p' switch overrides the environment variable, if both are set. If both http_proxy and https_proxy environment variables are set, it will favour the http_proxy environment variable. You can chanage this behaviour using the following arguments '-p $https_proxy'.


Air-gapped installation
-------------------------------------

Hopsworks can be installed in an air-gapped environment. We recommend that you contact sales@logicalclocks.com for help in installating in an environment without outbound Internet access.


Important Notes on Azure 
----------------------------------------

Azure VMs do not support private DNS by default, so you will need to add support for a private DNS space to the VMs used in Hopsworks. Follow these instructions AzureDNS_ to create the virtual machines for use in Hopsworks - but make sure your DNS zone name is very short (like 'hp' (2 chars)) and your VM name is short (like 'h1' (2 chars)). If it is longer, your fully qualified domain name might exceed 60 chars, and it will not work with OpenSSL/TLS. An error message will appear during installation duing the kagent::install.rb recipe, like this:

FQDN h1.hops.io.5zchkifi2mmetn0a5saw0eu1me.ax.internal.cloudapp.net is too long! It should not be longer than 60 characters

Once VMs have been created with a short private DNS name, you can follow the instructions above for single-host and multi-host installations for AWS and GCP.

.. _AzureDNS: https://docs.microsoft.com/en-us/azure/dns/private-dns-getstarted-portal


Quickstart (Single-Host Installation)
-----------------------------------------------------

First, you need to identify a server or virtual machine where Hopsworks will be installed (Centos/RHEL 7.x and Ubuntu 18.04 are supported). We recommend at least 32GB RAM, 8 CPUs, and 100 GB of free hard-disk space. If this server is air-gapped (has no Internet access), contact Logical Clocks for support.

You will need an account with sudo access. From that account, download and run the following script that installs Hopsworks:

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/1.4/hopsworks-installer.sh
   chmod +x hopsworks-installer.sh
   ./hopsworks-installer.sh

The above script will download and install Karamel on the same server that runs the script. Installation takes roughly 1 hr. To find out more about Karamel, read more below.


Quickstart (Multi-Host Installation)
-----------------------------------------------------

First, you need to identify hosts where Hopsworks will be installed (Centos/RHEL 7.x and Ubuntu 18.04 are supported). We recommend at least 32GB RAM, 8 CPUs, and 100 GB of free hard-disk space. If this server is air-gapped (has no Internet access), contact Logical Clocks for support. You pick one server as the head node and on the account on that server with sudo access, you need to setup password ssh access to all the worker nodes. You then need to setup passwordless ssh access - following instructions here: passwordless_ssh_.

On the head node, in the sudo account, download and run this script that installs Hopsworks on all hosts. It will ask you to enter the IP address of all the workers during installation:

.. _passwordless_ssh: ./cloud.html#password-less-ssh-access-from-the-head-node-to-worker-nodes

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/1.4/hopsworks-installer.sh
   chmod +x hopsworks-installer.sh
   ./hopsworks-installer.sh

The above script will download and install Karamel on the same server that runs the script. Karamel will install Hopsworks across all hosts. Installation takes roughly 1 hr, slightly longer for large clusters. To find out more about Karamel, read more below.



Karamel-based Installation
---------------------------------------------------

For on-premises (bare-metal) installations, you will need to prepare for installation by:

#. identifying a *master* host, from which you will run Karamel;

   #. the *master* must have a display for Karamel's user interface;
   #. the *master* must be able to ping (and connect using ssh) to all of the *target* hosts.

#. identifying a set of *target* hosts, on which the Hops software and 3rd party services will be installed.

   #. the *target* nodes should have http access to the open Internet to be able to download software during the installation process. (Cookbooks can be configured to download software from within the private network, by changing the 'download_url' chef attribute to a URL to a local http server IP address).

The *master* must be able to connect using SSH to all the *target* nodes, on which the software will be installed. If you have not already copied the *master's* public key to the *.ssh/authorized_keys* file of all *target* hosts, you can do so by preparing the machines as follows:

#. Create an openssh public/private key pair on the *master* host for your user account. On Linux, you can use the ssh-keygen utility program to generate the keys, which will by default be stored in the ``$HOME/.ssh/id_rsa and $HOME/.ssh/id_rsa.pub`` files. If you decided to enter a password for the ssh keypair, you will need to enter it again in Karamel when you reach the ``ssh`` dialog, part of Karamel's ``Launch`` step. 
#. Create a user account ``USER`` on the all the *target* machines with full sudo privileges (root privileges) and the same password on all *target* machines.
#. Copy the $HOME/.ssh/id_rsa.pub file on the *master* to the /tmp folder of all the *target* hosts. A good way to do this is to use ``pscp`` utility along with a file (``hosts.txt``) containing the line-separated hostnames (or IP addresss) for all the *target* machines. You may need to install the pssh utility programs (``pssh``), first.

.. code-block:: bash

   $sudo apt-get install pssh
   or
   $yum install pssh

   $vim hosts.txt
      # Enter the row-separated IP addresses of all target nodes in hosts.txt
           128.112.152.122
           18.31.0.190
           128.232.103.201
           .....

   $parallel-scp -h hosts.txt -P PASSWORD -i USER ~/.ssh/id_rsa.pub /tmp
   $parallel-ssh -h hosts.txt -i USER -P PASSWORD mkdir -p /home/USER/.ssh
   $parallel-ssh -h hosts.txt -i USER -P PASSWORD "cat /tmp/id_rsa.pub
          >> /home/USER/.ssh/authorized_keys && rm /tmp/id_rsa.pub"

Update your Karamel cluster definition file to include the IP addresses of the *target* machines and the ``USER`` account name. After you have clicked on the ``launch`` menu item, you will come to a ``Ssh`` dialog. On the ``ssh`` dialog, you need to open the advanced section. Here, you will need to enter the password for the ``USER`` account on the *target* machines (``sudo password`` text input box). If your ssh keypair is password protected, you will also need to enter it again here in the ``keypair password`` text input box.



#. Find out the network interface(s) on all servers:
   
These should be the same on all hosts. If they are not, you will need to add a new group in the Karamel cluster definition file for each different network interface.
On each *target* machine, run:
>ifconfig

#. Set the correct hostname
   
Hops uses TLS/SSL certificates for security and we generate certificates for services such as Kafka. It is important that the common name (CN) in the certificate is the same as the hostname returned by the command line operation:
  
.. code-block:: bash

   hostname
		
In ubuntu, the hostname returned by the ‘hostname’ command is in the file /etc/hostname

.. code-block:: bash

   cat /etc/hostname

On ubuntu versions with support for systemd, you can set the hostname with:
    
.. code-block:: bash

   hostnamectl set-hostname hadoop1
		
You also need to update the entries in /etc/hosts. 
For example, if you have an ubuntu machine with an old hostname in /etc/hosts:

.. code-block:: bash

   grep '127.0.1.1' /etc/hosts 
   127.0.1.1   vagrant1

You should remove this entry from /etc/hosts

If you decide to call your hosts 'hadoop1..hadoopN', then the hostname ‘hadoop1’ can be resolved to an IP address in /etc/hosts. This is our recommended way of resolving hostnames to IP addresses, rather than DNS which can be a source of problems if the DNS service is not working or slow or flakey.

.. code-block:: bash

   grep hadoop1 /etc/hosts
   >10.0.104.161  hadoop1
		

    
   #. Hosting installation files on the local network

Install an nginx server to the host deployment files for installation.
Edit nginx' port (do not use the default port 80, as it will clash with Hopsworks).
Copy the installation fiiles to '/var/www/html/software'.
On Ubuntu 18.04, run the following:

.. code-block:: bash

   sudo apt-get install nginx
   vi /etc/nginx/sites-available/default    # Set the port to '1111'
   sudo mkdir /var/www/html/software
   # Copy all the software to the folder: /var/www/html/software

When you install using Karamel, you should set the download url to be the URL of the nginx server and its software folder.
Here is an example of part of a cluster.yml:
  
.. code-block:: yaml

   name: HopsworksBaremetal
   baremetal:
       username: hops
   ...
   attrs:
     download_url: "http://192.168.0.2:1111/software"
   ...
     

   #. Gmail Account setup

You will need to create a new gmail account which will be used for email notifications, such as validating new Hopsworks accounts (when a user registers a new account, he/she receives an email and needs to click on a link in the email to validate his/her email address).

You need to enable gmail to send emails using a SMTP server. By default, a gmail account used by Hopsworks will not be allowed to send emails. You need to enable the following: go into the gmail account settings and 'allow less secure apps':

   Allow less secure apps: ON
		   

Upgrades
-----------------------------------------------------------------

When you have completed an installation, a cluster definition file is stored on the head server in `cluster-defns/hopsworks-installation.yml` - relative to the path of `hopsworks-installer.sh`. Move this file to a safe location (it contains any passwords set for different services). The yml file is also needed to perform an upgrade of Hopsworks using `:ref:`karamel`.


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
  
