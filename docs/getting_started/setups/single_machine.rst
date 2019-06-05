===========================
Single Machine Installation
===========================

The easiest way to start using Hopsworks locally is to import a VirtualBox appliance (ova) or let the Karamel
installation software install Hopsworks in a vm by running the :download:`simplesetup.sh <../simplesetup.sh>` script.

Both ways are described in detail below.

----------------------
Importing an ova image
----------------------

To successfully import and start the image, it is necessary to have VirtualBox installed on your workstation and at
least 20GB of storage and 16GB of main memory available. You can then follow these steps to import Hopsworks:

1. Download the 15G image_.
2. Import the image from the VirtualBox GUI or from the command line with ``vboxmanage import hopsworks-master.ova``
3. Start the vm in **headless** mode from the VirtualBox GUI or from the command line with ``vboxmanage startvm hopsworks0 --type headless``
4. Wait for approximately 3 minutes until all services have started and then access the Hopsworks at https://localhost:52988/hopsworks/ and login with username: admin@hopsworks.ai and password: admin. For further details on how to use Hopsworks, see :ref:`userguide`.

Advanced users might want to ssh in the vm. To do this, you need to:

1. Download the ssh key_.
2. Then do ``ssh -p 32516 -i insecure_private_key vagrant@localhost``


-------------------------------------
Deploying a Hopsworks vm with Karamel
-------------------------------------

If you are using a debian based distribution, you can run the :download:`simplesetup.sh <../simplesetup.sh>` script. (Tested on Ubuntu 18.04 LTS)
::

    ./simplesetup.sh

It is required that vagrant, virtualbox and chefdk are already installed on the host machine. If you run
::

    ./simplesetup.sh --install-deps

the script will automatically download and install the required versions of these dependencies.

After installing the dependencies, it will create and deploy the VM (needs ~16GB of RAM). This operation might take up to 1 hour, depending on your host machine specs.

To trace execution progress, tail the ``nohup`` file.
::

    tail -f karamel-chef/nohup

The script will ouput the port on which you can access Hopsworks when installation is completed and the demo user credentials.


If you want to destroy your VM, run the kill script
::

    ./karamel-chef/kill.sh

Going further
-------------

For detailed instructions on how to perform production deployments in-house or in the cloud, see :ref:`installation`.

.. _image: http://snurran.sics.se/hops/ova/hopsworks-master.ova
.. _key: http://snurran.sics.se/hops/ova/insecure_private_key
