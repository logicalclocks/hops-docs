HopsWorks User Guide
====================

If you are using 2-Factor authentication, jump ahead to "First Login with 2-Factor Authentication".

First Login (no 2-Factor Authentication)
------------------------------------------------

On initial installation, you can login with the default username and password.

::
   
    username: admin@kth.se
    password: admin

**If it goes wrong**

If login does not succeed, something has gone wrong during installation. The possible sources of error and the Web Application Server (Glassfish) and
the database (MySQL Clusters).
_Actions_:

* Double-check that system meets the minimum system requirements for HopsWorks. Is there enough available disk space and memory?
* Re-run the installation, as something may have gone wrong during installation.
* Investigate Glassfish misconfiguration problems. Is Glassfish running? is the hopsworks.war application installed? Are the JDBC connections working? Is JavaMail correct?)
* Investigate MySQL Cluster misconfiguration problems. Are the mgm server, data nodes, and MySQL server running? Do the hops and hopsworks databases exist and are they populated with tables and rows? If not, something went wrong during installation.

.. figure:: ../imgs/login.png
    :alt: HopsWorks Login Page
    :scale: 75
    :width: 200px
    :height: 234px	   
    :align: center
    :figclass: align-center
  
	 
First Login with 2-Factor Authentication
------------------------------------------------

First, you need to setup 2-factor authentication for the default account:
::
   
    username: admin@kth.se
    password: admin

Login to the target machine where HopsWorks is installed, and run:

.. code-block:: bash
   
    sudo /bin/hopsworks-2fa


It should return something like:


You now need to start 'Google Authenticator' on your smartphone. If you don't have 'Google Authenticator' installed, install it from your app store. It is available for free on  Android, iPhone, and Windows Phone platforms.

Now, add an account to Google Authenticator, and add as the account email 'admin@kth.se' and add as the key, the 'secret' value returned by '/bin/hopsworks-2fa'.
This should register your second factor on your phone.

You can now go to the start-page on Google Authenticator. You will need to supply the 6-digit number shown for 'admin@kth.se' when on the login page, along with the username and password.


**If it goes wrong**

* Double-check that system meets the minimum system requirements for HopsWorks. Is there enough available disk space and memory?



Register a New Account on HopsWorks
---------------------------------------------

.. figure:: ../imgs/user_registration.png
    :alt: HopsWorks User Registration
    :scale: 50
    :width: 200px
    :height: 250px	   
    :align: center
    :figclass: align-center

Register a new account with a valid email account. You should receive an email asking you to validate your account. The sender of the email will be neither the default email address "hopsworks@gmail.com"
or the gmail address you supplied while installing HopsWorks. If you do not receive an email address, wait a minute. If you still haven't received it, you need to troubleshoot.

** Validate the email address used in registration **

If you click on the link supplied in the registration email, it will validate your account and rdirect you to the login page.
**You will not be able to login until an administrator has validated your account.**. You can jump now to the Hops Administration Guide to see how to validate account registrations, if you have administrator privileges.


**If it goes wrong**

* Contact an administrator or go to the Administration Guide section of this document.
If you are an administrator:
* Does your organization have a firewall that blocks outbound SMTP access? HopsWorks needs SMTP outbound access over TLS using SSL (port 587 or 465).
* Is the Glassfish server up and running? Can you login to the Glassfish Administration console (on port 4848)?
* Inside Glassfish, check the JavaMail settings. Is the gmail username/password correct? Are the SMTP server settings correct (hostname/ip, port, protocol (SSL, TLS))?


Update your Profile/Password
---------------------------------------------

After you have logged in, in the upper right-hand corner of the screen, you will see your **email address with a caret icon**. Click on the caret icon, then click on the menu item **Account**.
A modal dialog will pop-up, from where you can change your password and other parts of your profile. You cannot change your email address and will need to create a new account if you wish to change your email address. You can also logout by clicking on the **sign out** menu item.

  
 Create a New Project
---------------------------------------------

You can create a project by clicking on the **New** button in the *Projects* box. This will pop-up a modal dialog, in which you enter the project name, an optional description, and select an optional set of services to be used in the project. You can also select an initial set of members for the project, who will be the the role of Data Scientist in the project. The roles can later be updated in the Project settings.

Delete a Project
---------------------------------------------

Right click on the project to be deleted in the projects box. You have the options to:

* **Remove and delete data sets**
* **Remove and keep data sets**.


Share a Data Set
---------------------------------------------

Click on the project that is owner of the Data Set. The click on *Data Sets*, and then right click on the Data Set to be shared and select **Share**. A popup dialog will then prompt you to select (1) a target project with which the *Data Set* is to be Shared and whether the *Data Set* will be shared as read-only (**Can View**) or as read-write (**Can edit**). To complete the sharing process, a Data Owner in the target project has to click on the shared Data Set, and then click on **Acccept** to complete the process.


Free-text Search 
---------------------------------------------


+------------------+----------------------------------------+
| Option           | Description                            |
+==================+========================================+
| **Search from**  | On landing page, enter the search term |
| **Landing Page** | in the search bar and press return.    |
|                  | Returns project names and Data Set     |
|                  | names that match the entered term.     |
+------------------+----------------------------------------+
| **Search from**  | From within the context of a project,  |
| **Project Page** | enter the search term in the search bar|
|                  | and press return. The search returns   |
|                  | any files or directories whose name or |
|                  | extended metadata matches the search   |
|                  | term.                                  |
+------------------+----------------------------------------+


Data Set Browser
---------------------------------------------

The Data Set tab enables you to browse Data Sets, files and directories in this project.
It is mostly used as a file browser for the project's HDFS subtree. You cannot navigate to
directories outside of this project's subtree.

Upload Data
---------------------------------------------

Files can be uploaded using HopsWorks' web interface. Go to the
project you want to upload the file(s) to. You must have the **Data Owner**
role for that project to be able to upload files. In the **Data Sets**
tab, you will see a button **Upload Files**.

+------------------+----------------------------------------+
| Option           | Description                            |
+==================+========================================+
| **Upload File**  | You have to have the **Data Owner**    |
|                  | role to be able to upload files.       |
|                  | Click on the **Upload File** button to |
|                  | select a file from your local disk.    |
|                  | Then click **Upload All** to upload    |
|                  | the file(s) you selected.              |
|                  | You can also upload folders.           |
+------------------+----------------------------------------+

Compress Files
---------------------------------------------

HopFS supports erasure-coded replication, which reduces storage requirements for large files by roughly 50%.
If a file consists of 10 file blocks or more (that is, if the file is larger than 640 MB in size, for a default block size of 64 MB), then it can
be compressed. Smaller files cannot be compressed. 

+------------------+----------------------------------------+
| Option           | Description                            |
+==================+========================================+
| **compress**     | You have to have the **Data Owner**    |
| **file**         | role to be able to compress files.     |
|                  | Select a file from your project.       |
|                  | Right-click and select **Compress**    |
|                  | to reduce the size of the file by      |
|                  | changing its replication policy from   |
|                  | triplica replication to Reed-Solomon   |
|                  | erasure coding.                        |
+------------------+----------------------------------------+


Jobs
---------------------------------------------

The Jobs tabs is the way to create and run YARN applications.
HopsWorks supports:

* Apache Spark,
* Apache Flink,
* MapReduce (MR),
* and bioinformatics data parallel frameworks Adam and SaasFee (Cuneiform).
    
+------------------+-----------------------------------------+
| Option           | Description                             |
+==================+=========================================+
| **New Job**      | Create a Job for any of the following   |
|                  | YARN frameworks by clicking **New Job**:|
|                  | Spark/MR/Flink/Adam/Cuneiform.          |
|                  | Step 1: enter job-specific parameters   |
|                  | Step 2: enter YARN parameters.          |
|                  | Step 3: click on **Create Job**.        |
+-------------------+----------------------------------------+
| **Run Job**      | After a job has been created, it can    |
|                  | be run by clicking on its **Run** button.|
+-------------------+----------------------------------------+

The logs for jobs are viewable in HopsWorks, as stdout and stderr files. These output files are also stored
in the **Logs/<app-framework>/<log-files>** directories.
After a job has been created, it can be **edited**, **deleted**, and **scheduled** by clickin on the **More actions** button.


Apache Zeppelin
---------------------------------------------

Apache Zeppelin is an interactive notebook web application for running Spark or Flink code on Hops YARN.
You can turn interpreters for Spark/Flink/etc on and off in the Zeppelin tab, helping, respectively, to reduce time required to execute a Note (paragraph) in Zeppelin or reclaim resources.
More details can be found at:

* https://zeppelin.incubator.apache.org/




Metadata Management
--------------------------
Metadata enables **data curation**, that is, ensuring that data is properly catalogued and accessible to appropriate users.

Metadata in HopsWorks is used primarily to discover and and retrieve relevant data sets or files by users by enabling users to
attach arbitrary metadata to Data Sets, directories or files in HopsWorks. Metadata is associated with an individual file
or Data Set or directory. This extended metadata is stored in the same database as the metadata for HopsFS and foreign keys link
the extended metadata with the target file/directory/Data Set, ensuring its integrity.
Extended metadata is exported to Elastic Search, from where it can be queried and the associated Data Set/Project/file/directory
can be identified (and acted upon).


MetaData Designer
---------------------------------------------

Within the context of a project, click on the **Data Sets** tab. From here, click on the **Metadata Designer** button.
It will bring up a designer dialog that can be used to:

* **Design a new Metadata Template**
* **Extend an existing Metadata Template**
* **Import/Export a Metadata Template**
    
The Metadata Designer can be used to define a Metadata template as one or more tables. Each table consists of a number of typed columns. Supported
column types are:

* **string**,
* **single-select selection box**,
* **multi-select selection box**.

Columns can also have constraints defined on them. On a column, click on cog icon (configure), where you can make the field:

* searchable: included in the Elastic Search index;
* required: when entering metadata, this column will make it is mandatory for users to enter a value for this column.

  
MetaData Attachment and Entry
---------------------------------------------

Within the context of a project, click on the **Data Sets** tab. From here, click on a Data Set. Inside the Data Set, if you
select any file or directory, the rightmost panel will display any extended metadata associated with the file or directory.
If no extended metadata is assocated with the file/directory, you will see "No metadata template attached" in the rightmost panel.
You can attach an existing metadata template to the file or directory by right-clicking on it, and selecting **Add metadata template**.
The metadata can then be selected from the set of *available templates* (designed or uploaded).

After one or more metadata templates have been attached to the file/directory, if the file is selected, the metadata templates are now visible
in the rightmost panel. The metadata can be edited in place by clicking on the **+** icon beside the metadata attribute. More than one extended
metadata value can be added for each attribute, if the attribute is a string attribute. 

Metadata values can also be removed, and metadata templates can be removed from files/directories using the Data Set service.
