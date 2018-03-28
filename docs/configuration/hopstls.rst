.. _hops_tls_configuration:

Hops SSL/TLS configuration
==========================

Hops is the only Hadoop distribution that supports SSL/TLS encryption
at the RPC layer. This provides encryption and authentication in all
intra-Hadoop communication links. In Hopsworks a registered user
holds a x509 certificate for every Project he/she has created. The CN
field in the certificate contains his/her project specific username
and that gives us the possibility to provide application level
authorization at the RPC server.

In order to enable this feature a set of configuration parameters
should be set. A description of the required properties is outlined
below.

In Hops the file name pattern for the **keystore** should be following:

* For the server keystore: *HOSTNAME__kstore.jks*, where HOSTNAME is
  the hostname of the machine
* For the client keystore: *USERNAME__kstore.jks* where USERNAME
  in Hopsworks is the project specific username in the form of
  PROJECTNAME__USERNAME

The file name pattern for the **truststore** should be following:

* For the server keystore: *HOSTNAME__tstore.jks*, where HOSTNAME is
  the hostname of the machine
* For the client keystore: *USERNAME__tstore.jks* where USERNAME
  in Hopsworks is the project specific username in the form of PROJECTNAME__USERNAME


First we will go through the properties in ``$HADOOP_HOME/etc/hadoop/ssl-server.xml``
configuration file. This file contains information regarding the
cryptographic material needed by the entities which run an RPC
server. The properties are superset of Apache Hadoop, a brief
description can be found `here`_.

.. _here: https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/EncryptedShuffle.html#ssl-server.xml_Shuffle_server_Configuration:


+---------------------------------------+--------------------------------------+---------------+
| property name                         | description                          | default value |
+=======================================+======================================+===============+
| ssl.server.truststore.location        | Location of the truststore in        |               |
|                                       | local filesystem                     |               |
+---------------------------------------+--------------------------------------+---------------+
| ssl.server.truststore.password        | Password of the truststore           |               |
+---------------------------------------+--------------------------------------+---------------+
| ssl.server.truststore.type            | Type of the truststore               | jks           |
+---------------------------------------+--------------------------------------+---------------+
| ssl.server.truststore.reload.interval | Reload interval of the               |               |
|                                       | truststore in ms                     | 10000         |
+---------------------------------------+--------------------------------------+---------------+
| ssl.server.keystore.location          | Location of the keystore in          |               |
|                                       | local filesystem                     |               |
+---------------------------------------+--------------------------------------+---------------+
| ssl.server.keystore.password          | Password of the keystore             |               |
+---------------------------------------+--------------------------------------+---------------+
| ssl.server.keystore.keypassword       | Password of the private key in the   |               |
|                                       | keystore                             |               |
+---------------------------------------+--------------------------------------+---------------+
| ssl.server.keystore.type              | Type of the keystore                 | jks           |
+---------------------------------------+--------------------------------------+---------------+
| ssl.server.keystore.reload.interval   | Reload interval of the keystore      |  10000        |
+---------------------------------------+--------------------------------------+---------------+
| ssl.server.keystore.reload.timeunit   | Keystore reload interval             | MILLISECONDS  |
|                                       | TimeUnit (Java TimeUnit)             |               |
+---------------------------------------+--------------------------------------+---------------+


Example of ``ssl-server.xml`` configuration file::
  
  <property>
    <name>ssl.server.truststore.location</name>
    <value>/srv/hops/kagent-certs/keystores/hopsworks0__tstore.jks</value>
    <description>Truststore to be used by NN and DN. Must be specified.
    </description>
  </property>
  
  <property>
    <name>ssl.server.truststore.password</name>
    <value>password</value>
    <description>Optional. Default value is "".
    </description>
  </property>

  <property>
    <name>ssl.server.truststore.type</name>
    <value>jks</value>
    <description>Optional. The keystore file format, default value is "jks".</description>
  </property>

  <property>
    <name>ssl.server.truststore.reload.interval</name>
    <value>10000</value>
    <description>Truststore reload check interval, in milliseconds.
    Default value is 10000 (10 seconds).</description>
  </property>

  <property>
    <name>ssl.server.keystore.location</name>
    <value>/srv/hops/kagent-certs/keystores/hopsworks0__kstore.jks</value>
    <description>Keystore to be used by NN and DN. Must be specified.
    </description>
  </property>

  <property>
    <name>ssl.server.keystore.password</name>
    <value>password</value>
    <description>Must be specified.</description>
  </property>

  <property>
    <name>ssl.server.keystore.keypassword</name>
    <value>adminpw</value>
    <description>Must be specified.</description>
  </property>

  <property>
    <name>ssl.server.keystore.type</name>
    <value>jks</value>
    <description>Optional. The keystore file format, default value is "jks".</description>
  </property>

  <property>
    <name>ssl.server.keystore.reload.interval</name>
    <value>10</value>
    <description>Optional. The keystore reload interval.</description>
  </property>

  <property>
    <name>ssl.server.keystore.reload.timeunit</name>
    <value>MINUTES</value>
    <description>Optional. The keystore reload interval TimeUnit, see Java TimeUnit.</description>
  </property>
  
  
Next is a list of properties required in ``$HADOOP_HOME/etc/hadoop/core-site.xml`` configuration file.
These properties enable SSL/TLS in the RPC server.


+------------------------------------------+--------------------------------------+----------------------------+------------------------+
| property name                            | description                          | sample value               | default value          |
+==========================================+======================================+============================+========================+
| ipc.server.ssl.enabled                   | Switch between SSL/TLS support for   | true                       | false                  |
|                                          | RPC server                           |                            |                        |
+------------------------------------------+--------------------------------------+----------------------------+------------------------+
| ipc.server.read.threadpool.size          | The number of threads utilized to    | 3                          | 1                      |
|                                          | read RPC requests                    |                            |                        |
+------------------------------------------+--------------------------------------+----------------------------+------------------------+
| hadoop.rpc.socket.factory.class.default  | Default Hadoop socket factory        | org.apache.hadoop.net.     | org.apache.hadoop.net. |
|                                          |                                      | HopsSSLSocketFactory       | StandardSocketFactory  |
+------------------------------------------+--------------------------------------+----------------------------+------------------------+
| hadoop.ssl.hostname.verifier             | Verifier used for the FQDN field at  | ALLOW_ALL                  | DEFAULT                |
|                                          | the presented x509 certificate       |                            |                        |
+------------------------------------------+--------------------------------------+----------------------------+------------------------+
| hadoop.ssl.enabled.protocols             | Enabled SSL protocols for the SSL    | TLSv1.2,TLSv1.1,TLSv1      | TLSv1                  |
|                                          | engine                               | SSLv3                      |                        |
+------------------------------------------+--------------------------------------+----------------------------+------------------------+
| hops.service.certificates.directory      | Directory that contains keystore and | /srv/hops/kagent-certs/    | /srv/hops/kagent-certs/|
|                                          | truststore used by the service/server| keystores                  | keystores              |
+------------------------------------------+--------------------------------------+----------------------------+------------------------+
| client.materialize.directory             | Directory where Hopsworks has already| /srv/hops/certs-dir/       | /srv/hops/domains/     |
|                                          | materialized the crypto material from| transient                  | domain1/kafkacerts     |
|                                          | the database for a specific user     |                            |                        |
+------------------------------------------+--------------------------------------+----------------------------+------------------------+
| client.rpc.ssl.enabled.protocol          | SSL protocol used by the client      | TLSv1.2                    | TLSv1                  |
+------------------------------------------+--------------------------------------+----------------------------+------------------------+


Example of ``core-site.xml`` configuration file::

  <property>
   <name>ipc.server.read.threadpool.size</name>
   <value>3</value>
  </property>
 
  <property>
   <name>ipc.server.ssl.enabled</name>
   <value>true</value>
  </property>

  <property>
   <name>hadoop.ssl.hostname.verifier</name>
   <value>ALLOW_ALL</value>
  </property>

  <property>
   <name>hadoop.rpc.socket.factory.class.default</name>
   <value>org.apache.hadoop.net.HopsSSLSocketFactory</value>
  </property>

  <property>
   <name>hadoop.ssl.enabled.protocols</name>
   <value>TLSv1.2,TLSv1.1,TLSv1,SSLv3</value>
  </property>

  <property>
   <name>hops.service.certificates.directory</name>
   <value>/srv/hops/kagent-certs/keystores</value>
  </property>

  <property>
   <name>client.materialize.directory</name>
   <value>/srv/hops/certs-dir/transient</value>
  </property>

  <property>
   <name>client.rpc.ssl.enabled.protocol</name>
   <value>TLSv1.2</value>
  </property>


In case where the ResourceManager is deployed in High-Availability mode some
extra configuration properties should be set in ``$HADOOP_HOME/etc/hadoop/yarn-site.xml``
in addition to the standard RM HA properties.


+---------------------------------------------+--------------------------------------+------------------------+------------------------+
| property name                               | description                          | sample value           | default value          |
+=============================================+======================================+========================+========================+
| yarn.resourcemanager.ha.enabled             | Standard YARN property to enable     | true                   | false                  |
|                                             | RM HA                                |                        |                        |
+---------------------------------------------+--------------------------------------+------------------------+------------------------+
| yarn.resourcemanager.ha.id                  | Standard YARN property to uniquely   | rm0                    |                        |
|                                             | identify an RM                       |                        |                        |
+---------------------------------------------+--------------------------------------+------------------------+------------------------+
| yarn.resourcemanager.ha.rm-ids              | Standard YARN property that lists    | rm0,rm1                |                        |
|                                             | the IDs of RMs                       |                        |                        |
+---------------------------------------------+--------------------------------------+------------------------+------------------------+
| yarn.resourcemanager.ha.cert.loc.address.ID | ipaddress:port for the               | 10.0.2.15:8012         |                        |
|                                             | CertificateLocalizationService       |                        |                        |
|                                             | running on each of the RMs           |                        |                        |
+---------------------------------------------+--------------------------------------+------------------------+------------------------+

Follows a sample of ``yarn-site.xml`` when RM HA is enabled for two RMs::
  
  <property>
   <name>yarn.resourcemanager.ha.enabled</name>
   <value>true</value>
  </property>
 
  <property>
   <name>yarn.resourcemanager.ha.id</name>
   <value>rm0</value>
  </property>
 
  <property>
   <name>yarn.resourcemanager.ha.rm-ids</name>
   <value>rm0,rm1</value>
  </property>
 
  <property>
   <name>yarn.resourcemanager.ha.cert.loc.address.rm0</name>
   <value>10.0.2.15:8012</value>
  </property>
 
  <property>
   <name>yarn.resourcemanager.ha.cert.loc.address.rm1</name>
   <value>10.0.2.16:8012</value>
  </property>



--------------------------------------
Certificate Revocation List validation
--------------------------------------
Since version 2.8.2.4 of Hops, Certificate Revocation List (CRL)
validation is supported for the RPC servers. The CRL should be placed
in publicly available location and it will be fetched periodically by
Hops services - ResourceManagers, NameNodes, NodeManagers and
DataNodes. Client's certificate is validated against this CRL and if
the certificate has been revoked, the connection is dropped. The
configuration properties for CRL validation should be in
``core-site.xml``. To enable CRL validation, RPC TLS **should** also
be enabled. 

+---------------------------------------+--------------------------------------+-------------------------------------------------+
| property name                         | description                          | default value                                   |
+=======================================+======================================+=================================================+
| hops.crl.validation.enabled           | Enable CRL validation                | false                                           |
+---------------------------------------+--------------------------------------+-------------------------------------------------+
| hops.crl.input.uri                    | URI where CRL whill be fetched from  |                                                 |
+---------------------------------------+--------------------------------------+-------------------------------------------------+
| hops.crl.output.file                  | File in the local filesystem where   |                                                 |
|                                       | the CRL will be written to           |                                                 |
+---------------------------------------+--------------------------------------+-------------------------------------------------+
| hops.crl.fetcher.interval             | CRL fetch interval (ns,us,ms,s,m,h,d)| 720m                                            |
+---------------------------------------+--------------------------------------+-------------------------------------------------+
| hops.crl.fetcher.class                | Fetcher class which will fetch the   | org.apache.hadoop.security.ssl.RemoteCRLFetcher |
|                                       | CRL periodically and write it to     |                                                 |
|                                       | local filesystem                     |                                                 |
+---------------------------------------+--------------------------------------+-------------------------------------------------+

The CRL section in ``core-site.xml`` whould look like this::

  <property>
   <name>hops.crl.validation.enabled</name>
   <value>true</value>
  </property>

  <property>
   <name>hops.crl.input.uri</name>
   <value>http://my_host/hops.crl.pem</value>
  </property>
  
  <property>
   <name>hops.crl.output.file</name>
   <value>hadoop_home/tmp/hops.crl.pem</value>
  </property>
  
  <property>
   <name>hops.crl.fetcher.interval</name>
   <value>2d</value>
  </property>

  <property>
   <name>hops.crl.fetcher.class</name>
   <value>org.apache.hadoop.security.ssl.RemoteCRLFetcher</value>
  </property>

  
--------------------------------------
Enabling RPC/IPC TLS with Karamel/Chef
--------------------------------------

If you are using `Karamel`_, then your cluster definition should look
like the following in order to enable RPC TLS and CRL validation. CRL input URI
would be ``HOPSWORKS_ENDPOINT/intermediate.crl.pem``, output file ``$HADOOP_TMP_DIR/hops_crl.pem``
and fetcher interval ``1d``. The ``DevRemoteCRLFetcher`` class is the same as ``RemoteCRLFetcher``
but trusts any web server certificate, usually in a development environment the certificate
will be self-signed::

  hops:
   rpc:
    ssl: true
   crl:
    validation_enabled: true
    fetcher_class: org.apache.hadoop.security.ssl.DevRemoteCRLFetcher


.. _Karamel: http://www.karamel.io/

