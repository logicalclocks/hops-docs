Choose the Installation Tool
=================================================

.. csv-table:: Different options for installation
   :header: "Platform", "Managed Hopsworks", "Hopsworks Cloud Installer", "Hopsworks Installer", "Karamel"
   :widths: 20, 20, 25, 20, 20

   "AWS", ":ref:`hopsworks-ai`", "N/A", ":ref:`hopsworks-installer`", ":ref:`karamel-installer`"
   "Azure", ":ref:`hopsworks-ai`", ":ref:`hopsworks-cloud-installer`", ":ref:`hopsworks-installer`", ":ref:`karamel-installer`"
   "GCP", "N/A", ":ref:`hopsworks-cloud-installer`", ":ref:`hopsworks-installer`", ":ref:`karamel-installer`"
   "On-Premises", "N/A", "N/A", ":ref:`hopsworks-installer`", ":ref:`karamel-installer`"
   "OpenStack, VMWare, etc", "N/A", "N/A", ":ref:`hopsworks-installer`", ":ref:`karamel-installer`"
      

**Installation Tips**
   
If you can use :ref:`hopsworks-ai` to run Hopsworks, that is our recommended approach. It is a managed platform, where we manage upgrades, backups, and provisioning. If you are on GCP or Azure, and you can use GCP tools or AZ tools, respectively, then jump to :ref:`hopsworks-cloud-installer`. Otherwise, the reccommended way to install Hopsworks is to use the :ref:`hopsworks-installer` script. A more manual way to install Hopsworks is to use :ref:`karamel-installer`. Karamel is used to upgrade manually installed Hopsworks clusters.

