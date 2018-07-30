===================================
Register a New Account on Hopsworks
===================================

The process for registering a new account is as follows:

#. Register your email address and details and use the camera from within Google Authenticator to store your 2nd factor credential;
#. Validate your email address by clicking on the link in the validation email you received;
#. Wait until an administrator has approved your account (you will receive a confirmation email).

.. figure:: ../../imgs/user_registration.png
    :alt: Hopsworks User Registration
    :width: 400px
    :height: 534px
    :scale: 70
    :align: center
    :figclass: align-center

    Hopsworks User Registration Page

.. raw:: latex

    \newpage

.. figure:: ../../imgs/two-factor-smartphone-qr-code.png
    :alt: Hopsworks QR Code needs to be scanned with Google/Microsoft Authenticator
    :width: 400px
    :height: 534px
    :scale: 70
    :align: center
    :figclass: align-center

    Two-factor authentication: Scan the QR Code with Google Authenticator


Register a new account with a valid email account. If you have two-factor authentication enabled, you will then need to scan the QR code to save it on your phone. If you miss this step, you will have to recover your smartphone credentials at a later stage.

In both cases, you should receive an email asking you to validate your account. The sender of the email will be either the default ``hopsworks@gmail.com`` or a gmail address that was supplied while installing Hopsworks. If you do not receive an email, wait a minute. If you still haven't received it, you should contact the administrator.

**Validate the email address used in registration**

If you click on the link supplied in the registration email, it will validate your account.
**You will not be able to login until an administrator has approved your account.** [#f1]_.

.. rubric:: Footnotes

.. [#f1] If you are an administrator, you can jump now to the Hops Administration Guide to see how to validate account registrations, if you have administrator privileges.

After your account has been approved, you can now go to HopsWork's login page and start your Google Authenticator application on your smartphone. On Hopsworks login page, you will need to enter

* the email address your registered with
* the password you registered with
* on Google Authenticator find the 6-digit number shown for the email address your registered with and enter it into Hopsworks.
