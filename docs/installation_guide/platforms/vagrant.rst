===========================
Vagrant (Virtualbox)
===========================

You can install HopsWorks and Hops on your laptop/desktop  with Vagrant. You will need to have the following software packages installed:

* chef-dk, version >0.5+
* git
* vagrant
* vagrant omnibus plugin
* virtualbox


The first step to setup the whole Hopsworks stack is to clone
`karamel-chef` cookbook which will orchestrate the running of the
other cookbooks.

::
   
   git clone https://github.com/hopshadoop/karamel-chef.git

Then ``cd karamel-chef/``. In the directory ``cluster-defns/`` there are some
predefined cluster definitions. The number at the beginning of the
file defines the number of VMs that will be created. You can use either
a single VM or 3 VMs where the services will be distributed in
different machines. In the directory ``vagrantfiles/`` are the virtual
machines specifications. The name of the files contains the OS of the
VM - Ubuntu or CentOS followed by the number of instances.

To start the installation you should run the ``./run.sh`` Bash
script. If you run the script without any parameters you will get a
small help message. The usage of the script is the following:

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


If you want to **destroy** your VMs execute the ``./kill.sh``
script. This will wipe out the installation and the virtual machines.


Default Setup
*****************

For instance if you want to create a Hopsworks setup with 3 VMs with
Ubuntu OS you would run:

::

   ./run.sh ubuntu 3 hopsworks

The output of the installation process is logged to ``nohup.out``
file. At any point you can run ``./run.sh ports`` to print the mapping of guest ports to host ports.

When the installation finishes you can access Hopsworks from your browser at http://127.0.0.1:8080/hopsworks. The default credentials are:

::

  username: admin@kth.se
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
