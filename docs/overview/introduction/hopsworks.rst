'===========================
Concepts in Hopsworks
===========================

..   .. contents:: Contents
..     :local:
..     :depth: 2


Hopsworks is the UI front-end to Hops. It supports user authentication through either a database realm, LDAP, or two-factor authentication. Other authentication realms are pluggable. There are both user and adminstrator views for Hopsworks. Hopsworks implements a perimeter security model, where command-line access to services is restricted  - jobs and applications are run from within Hopsworks UI (including Jupyter and Airflow).


Security
---------------------

Hopsworks' security model is designed to support the processing of sensitive Datasets in a shared (multi-tenant) cluster. The solution is based on Projects. Within a Project, a use may have one of two different roles, a *Data Owner* - who is like a superuser, and a *Data Scientist* - who is allowed run programs (do analysis), but not allowed to:

* copy data either in or out of the Project,
* cross-link the data in the Project with data in other Projects (even if she is a member of the other projects).

That is, the Project acts like a sandbox for the data within it.  

To realize this security model, Hopsworks implements dynamic role-based access control for projects. That is, users do not have static global roles. A user's privileges depend on what the user's active project is. For example, the user may be a *Data Owner* in one project, but only a *Data Scientist* in another project. Depending on which project is active, the user may be a *Data Owner* or a *Data Scientist*. The *Data Owner* role is strictly a superset of the *Data Scientist* role - everything a *Data Scientist* can do, a *Data Owner* can do.

.. figure:: ../../imgs/dynamic_roles.png
  :alt: Dynamic Roles ensures strong multi-tenancy in Hopsworks
  :scale: 60
  :figclass: align-center

  Dynamic Roles ensures strong multi-tenancy between projects in Hopsworks.

**A Data Scientist can**

* run applications (Jobs, Jupyter)
* upload programs to a restricted number of DataSets (*Resources*, *Jupyter*)

**A Data Owner can**

* upload/download data to the project,
* add and remove members of the project
* change the role of project members
* create and delete DataSets
* import and export data from DataSets
* design and update metadata for files/directories/DataSets



Datasets
----------------

A Dataset is a subtree of files and directories in HopsFS. Every Dataset has a home project, and by default can only be accessed by members of that project. A Data Owner for a project may choose to share a dataset with another project or make it public within the organization.

When you create a new Project, by default, a number of Datasets are created:

-  *Resources*: should be used to store programs and resources needed by programs. Data Scientists are allowed upload files to this dataset.
-  *Logs*: contains outputs (stdout, stderr) for applications run in Hopsworks. 
-  *Jupyter*: contains Jupyter notebook files. Data Scientists are allowed upload files to this dataset.
-  *Experiments*: contains runs for experiments launched using the HopsML API in PySpark/TensorFlow/Keras/PyTorch.
-  *Models*: contains trained machine learning model files ready for deployment in production.

   
..
   Users
   -----

   * Users authenticate with a valid email address
   * A 2nd factor can optionally be enabled for authentication. Supported devices are smartphones (Android, Apple,
     Windows) with an one-time password generator such as `Google Authenticator`_.


   .. _Google Authenticator: https://support.google.com/accounts/answer/1066447?hl=en

