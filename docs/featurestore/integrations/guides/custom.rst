Using the Feature Store from any Python environment
===================================================

Connecting to the Feature Store requires setting up a Feature Store API Key
and installing the Pandas SDK. This guide explains step by step how to connect to the Feature
Store from any Python environment.

.. contents:: :local:

Step 1: Generating an API key
-----------------------------

In Hopsworks, click on your username in the top-right corner and select *Settings* to open the user settings. 
Select *Api keys*. Give the key a name and select the *job*, *featurestore* and *project* scopes before creating the key. 
Copy the key into your clipboard and put it in a file called featurestore.key on the environment from which you want to
access the Feature Store.

.. _sagemaker_api_key.png: ../../../_images/sagemaker_api_key.png
.. figure:: ../../../imgs/feature_store/sagemaker_api_key.png
    :alt: Creating a Feature Store API Key
    :target: `sagemaker_api_key.png`_
    :align: center
    :figclass: align-center

Step 2: Installing the Pandas SDK
---------------------------------

To be able to access the Hopsworks Feature Store, the hopsworks-cloud-sdk library needs to be installed.
You can install the SDK with pip::

    !pip install hopsworks-cloud-sdk

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

    If you have trouble connecting, then ensure that your Feature Store instances
    can receive incoming traffic from your Python environment on ports *443*, *9083* and *9085*.