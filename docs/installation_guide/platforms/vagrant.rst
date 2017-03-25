===========================
Vagrant (Virtualbox)
===========================

You can install HopsWorks and Hops on your laptop/desktop  with Vagrant. You will need to have the following software packages installed:

* chef-dk, version >0.5+ (but not >0.8+)
* git
* vagrant
* vagrant omnibus plugin
* virtualbox

  You can now run vagrant, using:


.. code-block:: bash

    $ sudo apt-get install virtualbox vagrant
    $ vagrant plugin install vagrant-omnibus
    $ git clone https://github.com/hopshadoop/hopsworks-chef.git
    $ cd hopsworks-chef
    $ berks vendor cookbooks
    $ vagrant up

Default Setup
*****************

You can then access Hopsworks from your browser at http://127.0.0.1:8080/hopsworks. The default credentials are:

::

  username: admin@kth.se
  password: admin

You can access the Hopsworks administration application from your browser at http://127.0.0.1:8080/hopsworks/index.xhtml. The default credentials are:

::

  username: admin@kth.se
  password: admin


The Glassfish web application server is also available from your browser at http://127.0.0.1:4848. The default credentials are:

::

  username: adminuser
  password: adminpw


The MySQL Server is also available from the command-line, if you ssh into the vagrant host (``vagrant ssh``). The default credentials are:

::

  username: kthfs
  password: kthfs

It goes without saying, but for production deployments, we recommend changing all of these default credentials. The credentials can all be changed in Karamel during the installation phase.
