.. _Alert:
 
 
=================
Alerts
=================

The Alertmanager can be configured from the admin page by editing the configuration file.

To edit the alertmanager configuration yaml click on the bell icon in the admin page.

.. figure:: ../imgs/alerts/admin-alert.png
  :alt: Alerts
  :figclass: align-center
  :scale: 60%
 
  Go to Alerts.

The alertmanager config page shown below can be used to edit the configuration file as yaml or json.

.. figure:: ../imgs/alerts/admin-yml.png
  :alt: Receivers
  :figclass: align-center
  :scale: 60%
 
  Alertmanager config editor.

After editing the configuration click submit to save the new configuration and reload it to the alertmanager.

If the reload fails the old value will be restored.