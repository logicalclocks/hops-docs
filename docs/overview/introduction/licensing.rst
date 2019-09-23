==========================================================
Open-Source License
==========================================================

Hopsworks is provided under the AGPL-v3 open-source license. See the list of Hopsworks' dependencies and their licenses `here`_.


.. _here: https://github.com/logicalclocks/hopsworks/blob/master/LICENSE_OF_DEPENDENCIES.md





Hops Open-Source License (Apache v2 and AGPL-v3)
----------------------------------------------------

Hops combines Apache v2, GPL-2, and AGPL-v3 licensed code, from Hops,  MySQL Cluster, and DAL connectors, respectively. Hops
provides a DAL API (similar to JDBC) to enable Apache v2 servers (Hops) to talk to GPL-v2 metadata backend (MySQL Cluster).
Similar to JDBC, we dynamically link the jars for our DAL connector (AGPL-v3) the Hops code, and the DAL connector talks to GPL-v2 MySQL Cluster.
All three binaries are distributed separately during an installation.
Hops derives from Hadoop and, as such, it is available under the Apache version 2.0 open-
source licensing model. MySQL Cluster and its client connectors, on the other hand, are li-
censed under the GPL version 2.0 licensing model. The Logical Clocks DAL connector is licensed under AGPL-v3.
Similar to the JDBC model, we have introduced a Data Access Layer (DAL) API to bridge our code licensed under the Apache model
with the MySQL Cluster connector libraries, licensed under the GPL v2.0 model. The DAL
API is licensed under the Apache v2.0 model. The DAL API is statically linked to both Hops
and our client library (that implements the DAL API) for MySQL Cluster is licensed under AGPL-v3.
Even though our DAL API implementation statically links the DAL API (Apache v2) and talks to GPL-v2 MySQL Cluster, this is allowed, as stated in the MySQL
FOSS license exception. The FOSS License Exception permits use of the GPL-licensed MySQL
Client Libraries with software applications licensed under certain other FOSS licenses without
causing the entire derivative work to be subject to the GPL. However, to comply with the terms
of both licensing models, the DAL API needs to generic and different implementations of it
for different databases are possible. Although, we only currently support MySQL Cluster, you
are free to develop your own DAL API client and run Hops on a different database.
The main requirements for the database are support for transactions, read/write locks and at least read-committed isolation.

.. figure:: ../imgs/license-work-around.png

