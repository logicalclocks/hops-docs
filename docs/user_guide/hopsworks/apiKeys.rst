=================
API keys
=================

An API key allow a user or a program to make API calls
without having to authenticate with username and password.
To access an end-point using an API key a client should send the access token
using the ApiKey authentication scheme.

.. code-block:: bash

   GET /resource HTTP/1.1
   Host: server.hopsworks.ai
   Authorization: ApiKey <api_key>

Generate an API key
~~~~~~~~~~~~~~~~~~~~

To generate an API key choose Settings from the top right dropdown
menu and goto API keys tab. Give the new API key a unique name and
add a scope to limit the access rights given to the key.

.. figure:: ../../imgs/apiKey/apiKey.gif
   :alt: Create an API key
   :figclass: align-center
   :scale: 60%

   Create new API key


API Security
------------
Treat your secret API key as you would any other password:

1. Give API key the minimum required scope.
2. If an API key is stolen delete and recreate it.
3. Save your API key in a secure place.
4. You can't recover a lost API key.
