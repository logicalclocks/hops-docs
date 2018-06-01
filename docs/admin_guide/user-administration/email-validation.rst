======================================================
User fails to receive an email to validate her account
======================================================

* Does your organization have a firewall that blocks outbound SMTP access?
* Login to the Glassfish Webserver and check the JavaMail settings. The JNDI name should be *mail/BBCMail*. Is the gmail username/password correct? Are the smtp server settings correct (ip-address or hostname, port, protocol (SSL, TLS))?
