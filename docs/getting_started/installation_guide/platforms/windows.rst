===========================
Windows
===========================

You can also install Hopsworks on vagrant and Windows. You will need to follow the vagrant instructions as above (installing the same software packages) aswell as installing:

* Powershell

After cloning the github repo, from the powershell, you can run:

.. code-block:: bash

    $ cd hopsworks-chef
    $ berks vendor cookbooks
    $ vagrant up
