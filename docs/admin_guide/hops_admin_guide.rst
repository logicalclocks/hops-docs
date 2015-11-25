************************
Hops Administrator Guide
************************



HopsWorks Administration
------------------------


Activating users
************************

User fails to receive an email to validate her account
******************************************************

* Does your organization have a firewall that blocks outbound SMTP access?
* Login to the Glassfish Webserver and check the JavaMail settings. The JNDI name should be *mail/BBCMail*. Is the gmail username/password correct? Are the smtp server settings correct (ip-address or hostname, port, protocol (SSL, TLS))?

User receives email, but fails to validate the account
******************************************************

* Can you successfully access the HopsWorks homepage?
* Is the Glassfish webserver running and hopsworks.war application installed?
* Is MySQL Cluster running?

User successfully validates the account, but still can't login
************************************************************************

The user account status may not be in the correct state, see next section for how to update user account status.

User account has been disabled due to too many unsuccessful login attempts
****************************************************************************

You can login to the hopsworks database on the Mysql Server and update the status of the user account to valid using the user's email address (not admin@kth.se given below):

.. code-block:: bash
   
    sudo su
    /var/lib/mysql-cluster/ndb/scripts/mysql-client.sh hopsworks
    update users set status=4 where email='admin@kth.se'




Two-factor Authentication
*************************



Managing project quotas
***********************


**Managing project quotas**


* HopsFS Quotas
* HopsYARN Quotas


Glassfish Adminstration
-----------------------

If you didn't supply your own username/password for Glassfish administration during installation, you can login with the default username and password for Glassfish:

:: 

  username: adminuser
  password: adminpw


