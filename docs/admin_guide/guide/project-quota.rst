===========================
Managing Project Quotas
===========================

Each project is by default allocated a number of CPU hours in HopsYARN and an amount of available disk storage space in HopsFS:

* HopsYARN Quota

* HopsFS Quota

We recommend that you override the default values for the Quota during the installation process, by overriding the Chef attributes:

* hopsworks/yarn_default_quota

* hopsworks/hdfs_default_quota

In the **Projects** view, for any given project, the administrator can update the remaining amount of HopsYARN Quota (in CPU hours) and the amount disk space allocated in HopsFS for the project.


.. figure:: ../../imgs/project-administration.png
    :alt: Project Administration
    :scale: 100
    :align: center
    :figclass: align-center

    Project Administration: update quotas, disable/enable projects.
