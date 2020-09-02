====================
Vagrant (Virtualbox)
====================

You can install Hopsworks and Hops on your laptop/desktop  with Vagrant. You will need to have the following software packages installed:

* chef-dk, version >0.5+
* git
* vagrant
* vagrant omnibus plugin
* vagrant-disksize plugin 
* virtualbox

Also you need to run `vagrant plugin install vagrant-disksize` before continuing with the installation.

The first step to setup the whole Hopsworks stack is to clone
`karamel-chef` cookbook which will orchestrate the running of the
other cookbooks. Then ``cd karamel-chef/``. The quickstart is to spin up a single Ubuntu VM and install Hopsworks on it.

::
   
   git clone https://github.com/logicalclocks/karamel-chef.git
   cd karamel-chef
   ./run.sh ubuntu 1 hopsworks no-random-ports


In the directory ``cluster-defns/`` there are several
predefined cluster definitions. The ``run.sh`` command above picks the single-host Ubuntu cluster definition.
The number at the beginning of the file defines the number of VMs that will be created. You can use either
a single VM or 3 VMs where the services will be distributed in different machines. In the directory ``vagrantfiles/`` are the virtual
machines specifications. The name of the files contains the OS of the VM - Ubuntu or CentOS followed by the number of instances.
The parameters for the ``run.sh`` script are the following:

::

   ./run.sh OS NUMBER_OF_VMS NAME_OF_CLUSTER_DEFINITION [no-random-ports]
   ./run.sh ports

Where:

* OS is the desired operating system - ubuntu or centos.
* NUMBER_OF_VMS could be either 1 or 3 for the existing configurations.
* NAME_OF_CLUSTER_DEFINITION is the name of the cluster definition.
* By default Vagrant will forward the VMs ports to random ports in the
  host machine to avoid collisions. If you don't want it provide the
  ``no-random-ports`` option.


If you want to **destroy** your VMs, execute the ``./kill.sh``
script. This will purge the virtual machines and clean up local configuration files.


Default Setup
*****************

For instance if you want to create a Hopsworks setup with 3 VMs with
Ubuntu OS you would run:

::

   ./run.sh ubuntu 3 hopsworks no-random-ports

The output of the installation process is logged to ``nohup.out``
file. If you omit the ``no-random-ports`` option, you can run ``./run.sh ports`` to print the mapping of guest ports to host ports.

When the installation finishes you can access Hopsworks from your browser at http://127.0.0.1:8080/hopsworks. The default credentials are:

::

  username: admin@hopsworks.ai
  password: admin


The Glassfish web application server is also available from your browser at http://127.0.0.1:4848. The default credentials are:

::

  username: adminuser
  password: adminpw


The MySQL Server is also available from the command-line, if you ssh into the vagrant host (``vagrant ssh``). The default credentials are:

::

  username: kthfs
  password: kthfs

It goes without saying, but for production deployments, we recommend
changing all of these default credentials. The credentials can all be
changed in Karamel during the installation phase from the cluster
definitions. Check the available attributes in their respective cookbooks.
