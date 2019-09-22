.. _hopsworks-administration:

===================
User administration
===================

Clicking on the *User administration* icon on the admin panel, will lead you to the user administration panel. 
From here you will be able to see and manage the registered users.

Activating users
-----------------

When a user first registers on Hopsworks, they don't have any role as such they are not allowed to do any operation on the platform. Hopsworks users can have two roles: *Hops User* and *Hops Admin*.
*Hops User* is the base role, it allows users to create projects, invite and get invited into projects and operate within these projects. Each *Hops User* account, will then assume the role of *DataOwner* or *DataScientist* depending on which project they are operating in.
The *Hops Admin* role, allows all the operations allowed by the *Hops User* role and, in addition to those, it allows users to access the administration panel and manage the Hopsworks platform.

To activate a user account, an administration s

.. toctree::
   :maxdepth: 1
   :glob:
   
   user-administration/activate.rst
   user-administration/email-validation.rst
   user-administration/email-failure.rst
   user-administration/configure-email.rst
   user-administration/loginSuccess.rst
   user-administration/unsuccessfulLogin.rst
   user-administration/user-disable.rst
   user-administration/reactivate.rst
   user-administration/project-quota.rst
   user-administration/enable.rst


