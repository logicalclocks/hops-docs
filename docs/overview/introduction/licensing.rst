.. _hops-licensing:


==================================
Hopsworks Community License
=================================

Hopsworks is provided under the AGPLv3 open-source license. See the list of Hopsworks' dependencies and their licenses `here`_.


.. _here: https://github.com/logicalclocks/hopsworks/blob/master/LICENSE_OF_DEPENDENCIES.md




***************************
Hops License Compatibility
***************************

Hops combines Apache and GPLv2 licensed code, from Hops and MySQL Cluster, respectively, by
providing a DAL API (similar to JDBC). We dynamically link our DAL implementation for
MySQL Cluster with the Hops code. Both binaries are distributed separately.
Hops derives from Hadoop and, as such, it is available under the Apache version 2.0 open-
source licensing model. MySQL Cluster and its client connectors, on the other hand, are li-
censed under the GPL version 2.0 licensing model. Similar to the JDBC model, we have in-
troduced a Data Access Layer (DAL) API to bridge our code licensed under the Apache model
with the MySQL Cluster connector libraries, licensed under the GPL v2.0 model. The DAL
API is licensed under the Apache v2.0 model. The DAL API is statically linked to both Hops
and our client library for MySQL Cluster that implements the DAL API. Our client library
that implements the DAL API for MySQL Cluster, however, is licensed under the GPL v2.0
model, but static linking of Apache v2 code to GPL V2 code is allowed, as stated in the MySQL
FOSS license exception. The FOSS License Exception permits use of the GPL-licensed MySQL
Client Libraries with software applications licensed under certain other FOSS licenses without
causing the entire derivative work to be subject to the GPL. However, to comply with the terms
of both licensing models, the DAL API needs to generic and different implementations of it
for different databases are possible. Although, we only currently support MySQL Cluster, you
are free to develop your own DAL API client and run Hops on a different database.
The main requirements for the database are support for transactions, read/write locks and at least read-committed isolation.

.. figure:: imgs/license-work-around.png

