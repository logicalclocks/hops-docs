******************
Installation
******************
The Hops stack includes a number of services also requires a number of third-party distributed services:

* Java 1.7 (OpenJDK or Oracle JRE/JDK)
* NDB 7.4+ (MySQl Cluster)
* J2EE7 web application server (Glassfish by default)
* ElasticSearch 1.7+
  
Due to the complexity of installing and configuring all Hops' services, we recommend installing Hops using the automated installer Karamel/Chef (www.karamel.io). We do not provide documentation for installing and configuring all services, but for the curious, the Chef cookbooks that install our services are available at: https://github.com/hopshadoop.


Installation for Cloud Platforms
-------------

#. Download and install Karamel (www.karamel.io).
#. Run Karamel.
#. Click on the "Load Cluster Definition" menu item in Karamel. You are now prompted to select a cluster definition YAML file. Go to the examples/stable directory, and select a cluster definition file for your target cloud platform.
      
**Amazon Web Services (EC2)**

   #. HopsWorks on a single node: *hopsworks-1node-aws-large.yml*
   #. HopsWorks on three nodes: *hopsworks-3node-aws-large.yml*

**Google Compute Engine (GCE)**

   #. HopsWorks on a single node: *hopsworks-1node-gce-large.yml*
   #. HopsWorks on three nodes: *hopsworks-3node-gce-large.yml*

**OpenStack**

Coming soon..


Linux On-Premises (bare-metal)
-------------

You will need to prepare for installation by

#. identifying a *master* host, from which you will run Karamel (it should have a display for Karamel's user interface);
#. identifying a set of *target* hosts, on which the Hops software and 3rd party services will be installed.

The *master* should be able to connect using SSH to all the *target* nodes on which the software will be installed.
To do this, you will first need to prepare the machines as follows:

#. Create an openssh public/private key pair on the *master* host for your user account. On Linux, you can use the ssh-keygen utility program to generate the keys, which will by default be stored in the $HOME/.ssh/id_rsa and $HOME/.ssh/id_rsa.pub files. If you decided to enter a password for the ssh keypair, you will need to enter it again in Karamel when you reach the ``ssh`` dialog, part of Karamel's ``Launch`` step.
#. Create a user account ``USER`` on the all the *target* machines with full sudo privileges and the same password on all *target* machines. 
   
**Preparing Password-less SSH**

#. Copy the $HOME/.ssh/id_rsa.pub file on the *master* to the /tmp folder of all the *target* hosts. A good way to do this is to use ``pscp`` utility along with a file (``hosts.txt``) containing the line-separated hostnames (or IP addresss) for all the *target* machines. You may need to install the pssh utility programs (``pssh``), first.

.. code-block:: bash   

   $sudo apt-get install pssh
   or
   $yum install pssh
 
   $cat hosts.txt
           128.112.152.122
           18.31.0.190
           128.232.103.201      

   $pscp -h ``hosts.txt`` -P ``PASSWORD`` -i ``USER`` ~/.ssh/id_rsa.pub /tmp
   $pssh -h ``hosts.txt`` -i ``USER`` -P ``PASSWORD`` mkdir -p /home/``USER``/.ssh
   $pssh -h ``hosts.txt`` -i ``USER`` -P ``PASSWORD`` cat /tmp/id_rsa.pub >> /home/``USER``/.ssh/authorized_keys
   
Update your Karamel cluster definition file to include the IP addresses of the *target* machines and the ``USER`` account. After you have clicked on the ``launch`` menu item, you will come to a ``Ssh`` dialog. On the ``ssh`` dialog, you need to open the advanced section. Here, you will need to enter the password for the ``USER`` account on the *target* machines (``sudo password`` text input box). 
If you decided to enter a password for the ssh keypair, you will also need to enter it again here in the ``keypair password`` text input box.


**Centos/Redhat Notes**

Redhat is not yet supported by Karamel, but you can install Hops using Chef-solo by logging into each machine separately. The chef cookbooks are written to work for both Ubuntu and Redhat platforms.


Vagrant
-------------

You can install HopsWorks and Hops with Vagrant. You will need to have the following software packages installed:

* chef-dk, version 0.5+
* git
* vagrant
* virtualbox

You can now run vagrant, using:

.. code-block:: bash     

    $ git clone https://github.com/hopshadoop/hopsworks-chef.git
    $ cd hopsworks-chef
    $ berks vendor cookbooks
    $ vagrant up

You can then access Hopsworks from your browser at http://127.0.0.1:8080/hopsworks. The default credentials are:

* username: admin@kth.se
* password: admin

Windows
-------------

You can also install HopsWorks on vagrant and Windows. You will need to follow the vagrant instructions as above (installing the same software packages) aswell as installing:

* Powershell
After cloning the github repo, from the powershell, you can run:

.. code-block:: bash     

    $ cd hopsworks-chef
    $ berks vendor cookbooks
    $ vagrant up
  
Mac
-------------
You can follow the baremetal instructions to install for Apple Mac.
