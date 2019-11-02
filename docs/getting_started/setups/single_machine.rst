===========================
Single Machine Installation
===========================

The easiest way to start using Hopsworks locally is to let the Karamel
installation software install Hopsworks in a vm by running the :download:`simplesetup.sh <../simplesetup.sh>` script.


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
