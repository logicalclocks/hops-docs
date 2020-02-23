====================================
On-Premises Installation
====================================

Quickstart (Single-Host Installation)
-----------------------------------------------------

First, you need to identify a server or virtual machine where Hopsworks will be installed (Centos/RHEL 7.x and Ubuntu 18.04 are supported). We recommend at least 32GB RAM, 8 CPUs, and 100 GB of free hard-disk space. If this server is air-gapped (has no Internet access), contact Logical Clocks for support.

You will need an account with sudo access. From that account, download and run the following script that installs Hopsworks:

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/master/hopsworks-installer.sh
   chmod +x hopsworks-installer.sh
   ./hopsworks-installer.sh

The above script will download and install Karamel on the same server that runs the script. Installation takes roughly 1 hr. To find out more about Karamel, read more below.


Quickstart (Multi-Host Installation)
-----------------------------------------------------

First, you need to identify hosts where Hopsworks will be installed (Centos/RHEL 7.x and Ubuntu 18.04 are supported). We recommend at least 32GB RAM, 8 CPUs, and 100 GB of free hard-disk space. If this server is air-gapped (has no Internet access), contact Logical Clocks for support. You pick one server as the head node and on the account on that server with sudo access, you need to setup password ssh access to all the worker nodes. You then need to setup passwordless ssh access - following instructions eariler passwordless_ssh_.

On the head node, in the sudo account, download and run this script that installs Hopsworks on all hosts. It will ask you to enter the IP address of all the workers during installation:

.. _passwordless_ssh: http://snurran.sics.se/hops/tmp/html/installation_guide/platforms/cloud.html#password-less-ssh-access-from-the-head-node-to-worker-nodes

.. code-block:: bash

   wget https://raw.githubusercontent.com/logicalclocks/karamel-chef/master/hopsworks-installer.sh
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
On Ubuntu 16.04, run the following:

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
		   
