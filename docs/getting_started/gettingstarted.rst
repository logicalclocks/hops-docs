===========================
Getting Started
===========================

The simplest way to get up and running with Hops is to use our VM installer script.
It will create and initiate a single VM running on Vagrant with VirtualBox. Be aware that a Hops deployment runs many services, and therefore requires at least 10GB of RAM.

For detailed instructions on how to perform production deployments in-house or in the cloud, see :ref:`hops-installer`.

Hops on Vagrant
***************

Install dependencies
--------------
Firstly, install the following packages on your host machine:

* chef-dk 0.5+
* git
* vagrant
* vagrant omnibus plugin
* virtualbox


Get the code
----------------
Download the karamel-scripts from github
::
   git clone https://github.com/hopshadoop/karamel-chef.git

Run the installer
-----------------
Enter the cloned directory and run the setup script
::
   cd karamel-chef
   ./run.sh ubuntu 1 hopsworks

This will create and start a single-node deployment of Hops. The initiation takes up to an hour depending on the host system.

To track the progress of the initiation, check the ``nohup`` file where output logs are written.
::
   tail -f ./nohup

Once a success message has been printed in the ``nohup`` file, visit 127.0.0.1:8080/hopsworks with username admin@kth.se and password admin. If the port was already in use, use the "ports" command to see which port 8080 has been mapped to.
::
   ./run.sh ports

If you want to inspect the VM, simply run ``vagrant ssh`` in the same directory
::
   vagrant ssh
   
When you are done playing around
--------------------------------
To destroy the VM, simply run the kill script
::
   ./kill.sh
