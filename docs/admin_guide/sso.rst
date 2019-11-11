=======================
Kerberos Single Sign-On
=======================

Hopsworks enterprise edition supports Single Sign-On (SSO) using Kerberos

Karamel/Chef configuration
--------------------------

Kerberos SSO can be configured from the cluster definition, by specifying the following attributes:

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

Both the `Kerberos` and `LDAP` 