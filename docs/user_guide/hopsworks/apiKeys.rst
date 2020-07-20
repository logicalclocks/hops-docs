.. _API keys:

=================
API keys
=================

An API key allows a user or a program to make API calls
without having to authenticate with a username and password.
To access an endpoint using an API key, a client should send the access token
using the ApiKey authentication scheme.

.. code-block:: bash

   GET /resource HTTP/1.1
   Host: server.hopsworks.ai
   Authorization: ApiKey <api_key>

.. _api-key-generate:
Generate an API key
~~~~~~~~~~~~~~~~~~~~

To generate an API key choose Settings from the top right dropdown
menu and go to API keys tab. Give the new API key a unique name and
add a scope to limit the access rights given to the key. Adding a
scope means that you select the APIs that you want to allow this key
to access - e.g., 'serving' and 'project' if this key will be used to
access a model being served by Hopsworks.

.. figure:: ../../imgs/apiKey/apiKey.gif
   :alt: Create an API key
   :figclass: align-center
   :scale: 60%

   Create new API key


API key Security
----------------
Treat your secret API key as you would any other password:

1. Select the services for the API key scope.
2. If an API key is stolen, delete it and then recreate it.
3. Save your API key in a secure place.
4. You can't recover a lost API key.
