Version upgrades instructions
==============================

This section contains the actions to perform manually (if any), required updates to the cluster definition and heads up of potential problems (and solutions) you might encounter when upgrading to a specific version. 

Upgrades operate also on the database schemas, it is highly advised to take a backup of the database before starting the upgrade.

Hopsworks does not support online upgrades yet, so you need to shutdown all the services before starting the upgrade. You can do that from the Admin UI or by running `/srv/hops/kagent/kagent/bin/shutdown-all-local-services.sh` on all the machines.

During an update, use the same cluster definition you used for the installation. You can modify the attributes, change location of the services, but do not remove a service from the cluster definition just because it doesn't need to be updated. Karamel/Chef uses the location of the services in the cluster definition to template the configuration files. Removing services from the cluster definition might result in incomplete configuration files.

.. toctree::
   :maxdepth: 1

   upgrades/0_7_0.rst
   upgrades/0_10_0.rst
