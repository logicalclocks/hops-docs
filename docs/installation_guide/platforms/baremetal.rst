===========================
On-Premises (baremetal) Installation
===========================

For on-premises (bare-metal) installations, you will need to prepare for installation by:

#. identifying a *master* host, from which you will run Karamel;

   #. the *master* must have a display for Karamel's user interface;
   #. the *master* must be able to ping (and connect using ssh) to all of the *target* hosts.

#. identifying a set of *target* hosts, on which the Hops software and 3rd party services will be installed.

   #. the *target* nodes should have http access to the open Internet to be able to download software during the installation process. (Cookbooks can be configured to download software from within the private network, but this requires a good bit of configuration work for Chef attributes, changing all download URLs).


The *master* must be able to connect using SSH to all the *target* nodes, on which the software will be installed. If you have not already copied the *master's* public key to the *.ssh/authorized_keys* file of all *target* hosts, you can do so by preparing the machines as follows:

#. Create an openssh public/private key pair on the *master* host for your user account. On Linux, you can use the ssh-keygen utility program to generate the keys, which will by default be stored in the ``$HOME/.ssh/id_rsa and $HOME/.ssh/id_rsa.pub`` files. If you decided to enter a password for the ssh keypair, you will need to enter it again in Karamel when you reach the ``ssh`` dialog, part of Karamel's ``Launch`` step. We recommend no password (passwordless) for the ssh keypair.
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

   $pscp -h hosts.txt -P PASSWORD -i USER ~/.ssh/id_rsa.pub /tmp
   $pssh -h hosts.txt -i USER -P PASSWORD mkdir -p /home/USER/.ssh
   $pssh -h hosts.txt -i USER -P PASSWORD cat /tmp/id_rsa.pub
          >> /home/USER/.ssh/authorized_keys

Update your Karamel cluster definition file to include the IP addresses of the *target* machines and the ``USER`` account name. After you have clicked on the ``launch`` menu item, you will come to a ``Ssh`` dialog. On the ``ssh`` dialog, you need to open the advanced section. Here, you will need to enter the password for the ``USER`` account on the *target* machines (``sudo password`` text input box).
If your ssh keypair is password protected, you will also need to enter it again here in the ``keypair password`` text input box.


:Note: `Redhat/Centos is not yet supported by Karamel, but you can install Hops using Chef-solo by logging into each machine separately. The chef cookbooks are written to work for both the Debian/Ubuntu and Redhat/Centos platform families.`
