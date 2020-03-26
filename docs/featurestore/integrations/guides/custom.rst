Using the Feature Store from any Python environment (Kubeflow)
==============================================================

Connecting to the Feature Store requires setting up a Feature Store API Key
and installing the SDK. This guide explains step by step how to connect to the Feature
Store from any Python environment such as Kubeflow.

.. contents:: :local:

Step 1: Generating an API key
-----------------------------

In Hopsworks, click on your username in the top-right corner and select *Settings* to open the user settings. 
Select *Api keys*. Give the key a name and select the *job*, *featurestore* and *project* scopes before creating the key. 
Copy the key into your clipboard and put it in a file called featurestore.key on the environment from which you want to
access the Feature Store.

.. _custom_api_key.png: ../../../_images/custom_api_key.png
.. figure:: ../../../imgs/feature_store/custom_api_key.png
    :alt: Creating a Feature Store API Key
    :target: `custom_api_key.png`_
    :align: center
    :figclass: align-center

Step 2: Installing hopsworks-cloud-sdk
--------------------------------------

To be able to access the Hopsworks Feature Store, the hopsworks-cloud-sdk library needs to be installed.
You can install the SDK with pip. The major version of hopsworks-cloud-sdk needs to match the major version
of Hopsworks.

.. code-block:: bash

    pip install hopsworks-cloud-sdk~=YOUR_HOPSWORKS_VERSION

You can find your Hopsworks version under Settings/Versions inside your Hopsworks project:

.. _hopsworks_version.png: ../../../_images/hopsworks_version.png
.. figure:: ../../../imgs/feature_store/hopsworks_version.png
    :alt: Creating a Feature Store API Key
    :target: `hopsworks_version.png`_
    :align: center
    :figclass: align-center

Step 3: Connecting to the Feature Store
---------------------------------------

You can connect to the Feature Store by executing connect:

.. code-block:: python

    import hops.featurestore as fs
    fs.connect(
        'my_instance',                      # DNS of your Feature Store instance
        'my_project',                       # Name of your Hopsworks Feature Store project
        api_key_file='featurestore.key',    # The file with the api key
        secrets_store = 'local')

.. note::

    If you have trouble connecting, then ensure that your Feature Store
    can receive incoming traffic from your Python environment on ports *443*, *9083* and *9085*.