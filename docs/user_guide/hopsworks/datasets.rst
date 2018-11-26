===========================
Datasets
===========================

A Dataset is a subtree of files and directories in HopsFS. Every Dataset has a home project, and by default can only be accessed by members of that project. A Data Owner for a project may choose to share a dataset with another project or make it public within the organization.

When you create a new Project, by default, a number of Datasets are created:

-  *Resources*: should be used to store programs and resources needed by programs. Data Scientists are allowed upload files to this dataset.
-  *Logs*: contains outputs (stdout, stderr) for applications run in Hopsworks. 
-  *Jupyter*: contains Jupyter notebook files. Data Scientists are allowed upload files to this dataset.
-  *Experiments*: contains runs for experiments launched using the HopsML API in PySpark/TensorFlow/Keras/PyTorch.
-  *Models*: contains trained machine learning model files ready for deployment in production.

   
   **Hive** databases are also Datasets in Hopsworks - the Hive database's datafiles are stored in a HopsFS subtree. As such, Hive Databases can be shared between Projects, just like Datasets. **Feature Stores** are also stored in a HopsFS subtree, and can also be shared between Projects.
