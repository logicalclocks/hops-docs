=======================
Kerberos Single Sign-On
=======================

Hopsworks enterprise edition supports Single Sign-On (SSO) using SPNEGO. 

Karamel/Chef configuration
--------------------------

SSO can be configured from the cluster definition, by specifying the following attributes:

.. code-block:: yaml

  kerberos:
      enabled: true
      krb_conf_path: "/etc/krb5.conf"
      krb_server_key_tab_path: "/etc/security/keytabs/service.keytab"
      krb_server_key_tab_name: "service.keytab"
      spnego_server_conf: '\nuseKeyTab=true\nprincipal=\"HTTP/hopsworks0.logicalclocks.com@LOGICALCLOCKS.COM\"\nstoreKey=true\nisInitiator=false'
  ldap:
    enabled: false
    group_mapping: "Directory Administrators->HOPS_ADMIN;IT People-> HOPS_USER"
    user_id: "sAMAccountName" 
    user_givenName: "givenName"
    user_surname: "sn"
    user_email: "mail"
    user_search_filter: "sAMAccountName=%s"
    group_search_filter: "member=%d"
    krb_search_filter: "userPrincipalName=%s"
    attr_binary: "java.naming.ldap.attributes.binary"
    group_target: "cn"
    dyn_group_target: "memberOf"
    user_dn: ""
    group_dn: ""
    account_status: 2
    jndilookupname: "dc=example,dc=com"
    provider_url: "ldap://193.10.66.104:1389"
    attr_binary_val: "objectGUID"
    security_auth: "none"
    security_principal: ""
    security_credentials: ""
    referral: "follow"
    additional_props: ""

Both the `Kerberos` and `LDAP` attributes need to be specified, however differently from the :doc:`ldap`, only the `kerberos/enabled` attribute needs to be set to true.

- `krb_conf_path` contains the path to the `krb5.conf` used by SPNEGO get information about the default domain and the location of the Kerberos KDC. The file is copied by the recipe in `/srv/hops/domains/domain1/config`.

- `krb_server_key_tab_path` contains the path to the Kerberos service keytab. The keytab is copied by the recipe in `/srv/hops/domains/domain/config` with the name set in the `krb_server_key_tab_name` attribute.

- `spnego_server_conf` contains the configuration to be put in Glassfish `login.conf` to be able to configure the SPNEGO plugin. In particular it should contain `useKeyTab=true`, and the principal name to be used in the authentication phase. `isInitiator` should be set to `false`. 

The definition for the LDAP attributes is available at :doc:`ldap`.

Without Karamel/Chef
--------------------

An already deployed instance can be configured with Single Sign-On without the need of running Karamel/Chef.
Administrators should create a `JNDI` resource for the LDAP connector as described in the :doc:`ldap` documentation.

Moreover, administrators should manually copy `krb5.conf` and the `service.keytab` in `/srv/hops/domains/domain1/config`. They should also edit the file `/srv/hops/domains/domain/login.conf` with the value they would set for the attribute `spnego_server_conf`.

As for the LDAP instructions, administrators should set `kerberos_auth` to `True` in the :doc:`variables` panel. This will make the LDAP configuration option appear in the Admin panel. From the LDAP configuration panel, they will be able to configure Hopsworks' LDAP connection.

Migrating existing users
------------------------

Using Expat_ there is the possibility of migrating existing local users and map them to LDAP users. 

.. _Expat: https://github.com/logicalclocks/expat

Allow non-LDAP users
--------------------

As for the :doc:`ldap`, even with Single Sign-On enabled, users will still be able to register with their email addresses. It's up to the administrators to enforce a Single Sign-On-only account policy. 