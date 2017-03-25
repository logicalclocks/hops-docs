===========================
Apple OSX/Mac
===========================

First, install protobuf and cmake:

.. code-block:: bash

    $ brew install protobuf250
    $ brew install cmake

Note: you need protobuf version 2.5 (not 2.6). You can check if it's already installed with

.. code-block:: bash

    $ protoc --version
    libprotoc 2.5.0

Hops runs on JDK 1.7, so you should have that installed (download it `here`_). However, due to some inconsistencies between Java version you'll have to create a symlink like this:

.. code-block:: bash

    cd /Library/Java/JavaVirtualMachines/jdk1.7.0_17.jdk/Contents/Home/
    sudo mkdir Classes && cd Classes
    sudo ln -s ../jre/lib/rt.jar classes.jar

.. _here: http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html

You should now be able to clone the repositories and build the code.
