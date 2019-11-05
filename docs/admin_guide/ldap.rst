================
LDAP integration
================

Hopsworks enterprise edition support LDAP integration for user login. 

Karamel/Chef configuration
--------------------------

LDAP integration can be configured from the cluster definition, by specifying the following attributes: 

.. code-block:: yaml

 ldap:
   enabled: true
   group_mapping: "Directory Administrators->HOPS_ADMIN;IT People-> HOPS_USER"
   user_id: "uid"
   user_givenName: "givenName"
   user_surname: "sn"
   user_email: "mail"
   user_search_filter: "uid=%s"
   group_search_filter: "member=%d"
   attr_binary: "java.naming.ldap.attributes.binary"
   group_target: "cn"
   dyn_group_target: "memberOf"
   user_dn: ""
   group_dn: ""
   account_status: 2
   jndilookupname: "dc=example,dc=com"
   provider_url: "ldap://193.10.66.104:1389"
   attr_binary_val: "entryUUID"
   security_auth: "none"
   security_principal: ""
   security_credentials: ""
   referral: "ignore"
   additional_props: ""

- `group_mapping` allows you to specify a mapping between LDAP groups and Hopsworks groups. At the moment Hopsworks supports mapping only with `HOPS_ADMIN` and `HOPS_USER` groups. If nothing is specified, users won't get any default group and administrators should assign one manually. Users are not allowed to login as long as they don't belong to any group.

- `user_id`, `user_givenName`, `user_suername`, `user_email` are the fields Hopsworks will lookup in LDAP the first time a user tries to login.

- `jndilookupname` should contain the LDAP domain.

- `attr_binary_val` is the binary unique identifier that will be used in subsequents login to identify the user.

- `account_status` contains the default value for.

- `security_auth` can be "none" or "simple".

- `security_principal` contains username of the user that is allowed to query LDAP.

- `security_credentials` contains the password of the user to query LDAP.

Without Karamel/Chef
--------------------

