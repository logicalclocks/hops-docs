.. _hopsworks-administration:

==================
Hopsworks settings
==================

Clicking on the *Edit variables* icon on the admin panel, will lead to the configuration management panel.
From here administrators are able to change the configuration and behavior of Hopsworks.

Hopsworks UI doesn't have a configuration file, instead the configuration is stored in the database in the `hopsworks.variables` table. 

This panel in the admin UI allows easy access to that configuration. Administrators are able to view and edit it from the panel.
Administrators can edit the value of a variable by clicking on the pencil. The new configuration will not take affect until the `Reload variables` button has been clicked. 

Be aware that some variables in the Variables view are meant to be static, meaning that they are populated and modified by Karamel/Chef during installations and or upgrades. Version numbers are an example of this case.

Moreover, changing an attribute in this table only affects Hopsworks application. As an example, let's assume the administrator changes the value of the `rm_port` which specifies on which port Hopsworks should contact the Yarn Resource Manager when submitting jobs. Changing the value on the Hopsworks side, won't affect on which port the Resource Manager is listening on, but it will change the port that the Hopsworks application believes the Resource Manager is listening on. 