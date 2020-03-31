Databricks Quick Start
======================

This guide shows how to quickly get started with using the Feature Store from Databricks.
A more complete guide is available: :ref:`databricks`.

.. contents:: :local:

Step 1: Deploying Hopsworks to the Databricks VPC
-------------------------------------------------

The easiest way to connect to the Feature Store from Databricks is to deploy Hopsworks to the same
VPC as your Databricks clusters. For other options, including VPC peering, see :ref:`databricks`.

.. include:: ../../../featurestore/integrations/guides/databricks.rst
  :start-after: .. include-1-start
  :end-before:  .. include-1-stop

Step 1.3: Deploying a new Hopsworks clusters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In Hopsworks.ai, select *Run a new instance*:

.. _create-instance.png: ../../../_images/create-instance.png
.. figure:: ../../../imgs/hopsworksai/create-instance.png
    :alt: Deploying a Hopsworks cluster
    :target: `create-instance.png`_
    :align: center
    :figclass: align-center

As location, choose the region you use for Databricks. Select the VPC with a name starting with *databricks-*.
Finally, select the subnet in the *Availability Zone* of your Databricks cluster and deploy.

.. _configure_databricks.png: ../../../_images/configure_databricks.png
.. figure:: ../../../imgs/hopsworksai/configure_databricks.png
    :alt: Deploying Hopsworks in the Databricks VPC
    :target: `configure_databricks.png`_
    :align: center
    :figclass: align-center

Wait for the cluster to start. After starting, select *Feature Store* and *Online Feature Store* under *Exposed Services*
and press *Update*. This will update the *Security Group* attached to the Hopsworks instance to allow incoming traffic on the relevant ports.

You can now log in to Hopsworks with the given link and credentials:

.. _open-ports.png: ../../../_images/open-ports.png
.. figure:: ../../../imgs/hopsworksai/open-ports.png
    :alt: Outside Access to the Feature Store
    :target: `open-ports.png`_
    :align: center
    :figclass: align-center

.. include:: ../../../featurestore/integrations/guides/databricks.rst
  :start-after: .. include-2-start
  :end-before:  .. include-2-stop

Step 3: Storing the API Key in the AWS Secrets Manager
------------------------------------------------------

.. include:: ../../../featurestore/integrations/guides/databricks.rst
  :start-after: .. include-3-start
  :end-before:  .. include-3-stop

Step 4: Connecting to the Feature Store from Databricks
-------------------------------------------------------

Step 4.1: Installing the hops SDK
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: ../../../featurestore/integrations/guides/databricks.rst
  :start-after: .. include-4-start
  :end-before:  .. include-4-stop

Step 4.2: Configuring Databricks to use the Feature Store
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: ../../../featurestore/integrations/guides/databricks.rst
  :start-after: .. include-5-start
  :end-before:  .. include-5-stop

.. note::

  You have to change **spark.hadoop.hive.metastore.uris** in the config to point at the Private DNS of the Feature Store
  for it to be reachable. For instance, change the config entry
  spark.hadoop.hive.metastore.uris thrift://my-instance.aws.hopsworks.ai:9083 to 
  spark.hadoop.hive.metastore.uris thrift://my-instance.us-west-2.compute.internal:9083.

  The *Private DNS* of your Feature Store instance deployed can be found in EC2 on the AWS Management Console:

  .. _hopsworks_instance.png: ../../../_images/hopsworks_instance.png
  .. image:: ../../../imgs/feature_store/hopsworks_instance.png
      :alt: Identifiying your Feature Store DNS name
      :target: `hopsworks_instance.png`_
      :align: center

.. include:: ../../../featurestore/integrations/guides/databricks.rst
  :start-after: .. include-5.1-start
  :end-before:  .. include-5.1-stop

Step 4.3: Connecting to the Feature Store
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: ../../../featurestore/integrations/guides/databricks.rst
  :start-after: .. include-6-start
  :end-before:  .. include-6-stop

.. code-block:: python

 import hops.featurestore as fs
 fs.connect(
    'my_instance.aws.hopsworks.ai', # Hopsworks.ai address of your Feature Store instance
    'my_project',                   # Name of your Hopsworks Feature Store project
    region_name='my_aws_region',    # AWS region in which you stored the API Key
    secrets_store='secretsmanager', # Either parameterstore or secretsmanager
    hostname_verification=True)     # Disable for self-signed certificates   

Step 3: Next steps
------------------
Check out our other guides for how to get started with Hopsworks and the Feature Store:

.. hlist:

* `Feature Store Tour Notebook <https://github.com/logicalclocks/hops-examples/blob/master/notebooks/featurestore/FeaturestoreTourPython.ipynb>`_
* Get started with the :ref:`feature-store`
* Get started with Machine Learning on Hopsworks: :ref:`hops-ml`
* Get started with Hopsworks: :ref:`userguide`
* Code examples and notebooks: `hops-examples <https://github.com/logicalclocks/hops-examples>`_