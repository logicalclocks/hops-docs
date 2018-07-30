===========================
If it goes wrong
===========================

Contact an administrator or go to the Administration Guide section of this document. If you are an administrator:

* Does your organization have a firewall that blocks outbound SMTP access? Hopsworks needs SMTP outbound access over TLS using SSL (port 587 or 465).
* Is the Glassfish server up and running? Can you login to the Glassfish Administration console (on port 4848)?
* Inside Glassfish, check the JavaMail settings. Is the gmail username/password correct? Are the SMTP server settings correct (hostname/ip, port, protocol (SSL, TLS))?


*User fails to receive an email to validate her account*

* This may be a misconfigured gmail address/password or a network connectivity issue.
* Does your organization have a firewall that blocks outbound SMTP access?
* For administrators: was the correct gmail username/password supplied when installing?
* If you are not using a Gmail address, are the smtp server settings correct (ip-address or hostname, port, protocol (SSL, TLS))?

*User receives the validate-your-email message, but is not able to validate the account*

* Can you successfully access the Hopsworks homepage? If not, there may be a problem with the network or the webserver may be down.
* Is the Glassfish webserver running and hopsworks-war, hopsworks-ear application installed, but you still can't logon? It may be that MySQL Cluster is not running.
* Check the Glassfish logs for problems and the Browser logs.


*User successfully validates the account, but still can't login*

The user account status may not be in the correct state, see next section for how to update user account status.

*User account has been disabled due to too many unsuccessful login attempts*

From the Hopsworks administration application, the administrator can re-enable the account by going to "User Administration" and taking the action "Approve account".


*User account has been disabled due to too many unsuccessful login attempts*

Contact your system administrator who will re-enable your account.
