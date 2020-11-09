
==========================================================
Troubleshooting
==========================================================

When it comes to deploy Hopsworks, not two environments are alike and sometimes issues arise.
This section will guide you through some common failures scenarios, how to debug them and possible fixes.

Invalid Yaml file
=================

If you are trying to install Hopsworks behind a corporate firewall you might encounter a similar error:

.. code-block:: bash

    ERROR [2020-10-15 12:38:53,007] se.kth.karamel.webservice.KaramelServiceApplication: Invalid yaml file; Invalid attributes, all used attributes must be defined in metadata.rb files: [hops/tls/enabled, hops/tls/crl_fetcher_interval, elastic/opendistro_security/epipe/username, hops/rmappsecurity/actor_class, hopsworks/application_certificate_validity_period, elastic/opendistro_security/admin/username, hopsworks/kagent_liveness/threshold, elastic/opendistro_security/audit/enable_transport, hopsworks/requests_verify, hops/tls/crl_fetcher_class, elastic/opendistro_security/elastic_exporter/username, elastic/opendistro_security/audit/enable_rest, hops/yarn/pcores-vcores-multiplier, mysql/password, hops/yarn/cgroups_strict_resource_usage, hopsworks/featurestore_online, hopsworks/admin/password, hops/yarn/detect-hardware-capabilities, hopsworks/admin/user, elastic/opendistro_security/logstash/password, hops/tls/crl_enabled, hops/yarn/system-reserved-memory-mb, hopsworks/encryption_password, elastic/opendistro_security/epipe/password, alertmanager/email/to, elastic/opendistro_security/jwt/exp_ms, install/dir, prometheus/retention_time, alertmanager/email/smtp_host, elastic/opendistro_security/kibana/password, alertmanager/email/from, hopsworks/master/password, ndb/NoOfReplicas, elastic/opendistro_security/kibana/username, hive2/mysql_password, install/kubernetes, hopsworks/kagent_liveness/enabled, hopsworks/https/port, ndb/DataMemory, elastic/opendistro_security/admin/password, install/cloud, elastic/opendistro_security/logstash/username, elastic/opendistro_security/elastic_exporter/password]

This issue is caused by the fact that Hopsworks' deployment tool (Karamel) is trying to reach GitHub to download the metadata to validate the cluster definition. 
The solution to this issue is to use the `-p` flag in the installer script. This allows you to specify a HTTP proxy for Karamel to use as explained here: :ref:`http-proxy`.