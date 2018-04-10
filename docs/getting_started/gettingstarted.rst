===========================
Getting Started
===========================

Download the sandbox
--------------------

The easiest way is to try Hops is to `download the sandbox
<http://www.hops.io/get-started/>`_. This will run on any platform supporting a recent version of VirtualBox.

Run the installer
-----------------

Otherwise, if you are using a debian based distribution, you can run the :download:`simplesetup.sh <simplesetup.sh>` script. (Tested on Ubuntu 16.04)
::

    ./simplesetup.sh

It will install the required versions of virtualbox, vagrant and chefdk, and create a single node VM (needs ~15GB of RAM).

After installing the dependencies, it will create and initiate the VM. This will take up to 1 hour depending on your host machine.
To trace execution progress, tail the ``nohup`` file.
::

    tail -f karamel-chef/nohup

Once you see a success message, visit 127.0.0.1:8080/hopsworks with username ``admin@kth.se`` and password ``admin``.

If you want to destroy your VM, run the kill script
::

    ./karamel-chef/kill.sh

Going further
-------------

For detailed instructions on how to perform production deployments in-house or in the cloud, see :ref:`hops-installer`.