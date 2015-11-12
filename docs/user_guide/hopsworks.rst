HopsWorks User Guide
====================

If you are using 2-Factor authentication, jump ahead to "First Login with 2-Factor Authentication".

.. figure:: ../imgs/login.png
    :alt: HopsWorks Login Page
    :width: 300px
    :height: 334px	   
    :align: center
    :figclass: align-center

First Login (no 2-Factor Authentication)
------------------------------------------------

You can first login with the default username and password.
username: admin@kth.se
password: admin

*If it goes wrong*
	 If login does not succeed, something has gone wrong during installation. The possible sources of error and the Web Application Server (Glassfish) and
the database (MySQL Clusters).
_Actions_:

* Double-check that system meets the minimum system requirements for HopsWorks. Is there enough available disk space and memory?
* Re-run the installation, as something may have gone wrong during installation.
* Investigate Glassfish misconfiguration problems. Is Glassfish running? is the hopsworks.war application installed? Are the JDBC connections working? Is JavaMail correct?)
* Investigate MySQL Cluster misconfiguration problems. Are the mgm server, data nodes, and MySQL server running? Do the hops and hopsworks databases exist and are they populated with tables and rows? If not, something went wrong during installation.

	 
First Login with 2-Factor Authentication
------------------------------------------------

First, you need to setup 2-factor authentication for the default account:
username: admin@kth.se
password: admin

Login to the target machine where HopsWorks is installed, and run:

sudo /bin/hopsworks-2fa

It should return something like:


You now need to start 'Google Authenticator' on your smartphone. If you don't have 'Google Authenticator' installed, install it from your app store. It is available for free on  Android, iPhone, and Windows Phone platforms.

Now, add an account to Google Authenticator, and add as the account email 'admin@kth.se' and add as the key, the 'secret' value returned by '/bin/hopsworks-2fa'.
This should register your second factor on your phone.

You can now go to the start-page on Google Authenticator. You will need to supply the 6-digit number shown for 'admin@kth.se' when on the login page, along with the username and password.


*If it goes wrong*

* Double-check that system meets the minimum system requirements for HopsWorks. Is there enough available disk space and memory?
* 


Registering an Account on HopsWorks
---------------------------------------------

.. figure:: ../imgs/user_registration.png
    :alt: HopsWorks User Registration
    :width: 100px
    :height: 150px	   
    :align: center
    :figclass: align-center

Register a new account with a valid email account. You should receive an email asking you to validate your account. The sender of the email will be neither the default email address "hopsworks@gmail.com"
or the gmail address you supplied while installing HopsWorks. If you do not receive an email address, wait a minute. If you still haven't received it, you need to troubleshoot.

investigate the JavaMail settings.

You can login

*If it goes wrong*

* Login need to login to the Glassfish Webserver and

If you want to test the new account, you can jump to the Administration Guide to validate account requests.
