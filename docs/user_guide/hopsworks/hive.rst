===========================
HopsHive
===========================

Introduction
------------

HopsHive is a fork for Apache Hive. The main difference between Apache Hive and HopsHive is that when a user deletes their data, the metadata describing databases, tables and partitions is deleted as well, hence maintaining the metadata storage consistent against the filesystem.

This page serves as a guide on how to use Hive from within Hopsworks. For information on how to write HiveQL (the language used to query the data) and configuration parameters available for tweaking, please refer to the Apache Hive `wiki`_

.. _wiki: https://cwiki.apache.org/confluence/display/Hive/Home

Using HopsHive with Hopsworks
------------------------------

In order to use HopsHive from Hopsworks, users first need to create a database. Each project can have *at most one* Hive database, which is created when the Hive service is enabled for the project. Users can enable the Hive service either when creating a new project or via the *Settings* section.

Once the database is created, users are able to see in the *Datasets* view a new dataset called ``projectName.db``. This new dataset is the Hive database for the project and contains Hive's data.

Users can then run queries using *Apache Zeppelin* (the Zeppelin service needs to be enabled for the project). To run a query, users need to create a notebook and use ``HopsHive`` as the interpreter. This can be done in either one of three ways:

1. Selecting ``hopshive`` from the interpreter list when creating the notebook

2. Selecting it as the default interpreter in the interpreter settings from within the notebook (`more info <https://zeppelin.apache.org/docs/latest/manual/interpreters.html>`_.)

3. Typing ``%hopshive`` at the top of each paragraph.

After that, users can start writing and running queries.
One caveat when writing queries in Zeppelin is that the ``;`` character at the end of a query is not allowed and, in general, it is good practice to spread queries over multiple paragraphs.

Workflow example
----------------

The following is an example of a standard workflow when using Hive.

The steps are the following: get the raw data into Hopsworks, load the data into Hive, convert the data in a more storage and computationaly efficient format, such as *ORC*, and finally query the new table.
The steps are the following:

1. **Load the raw data into Hopsworks**: The easiest way to do it is to create a new dataset within the project and upload the data. Please remember to not generate the ``README.md`` file (or delete it after creating the dataset). This is because when creating the external table on the dataset, Hive will use all the files contained in the directory, README included if present. An alternative approach would be to create a directory inside the dataset and point Hive to that directory. Please note that, as the Zeppelin notebooks are run as the *ProjectGenericUser*, which is a user automatically created for your project and automatically added to each dataset user group, to be able to operate on the data, the dataset needs to be set to be editable by right clicking on the dataset and selecting *Make Editable*.

2. **Make Hive aware of the raw data**: To load the data into Hive, users can create a new Zeppelin Notebook, choosing ``hopshive`` as default interpreter and write a query to create an external table.

An example of query can be the following::

    create external table sales(
      street string,
      city string,
      zip int,
      state string,
      beds int,
      baths int,
      sq__ft float,
      sales_type string,
      sale_date string,
      price float,
      latitude float,
      longitude float)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    LOCATION '/Projects/hivedoc/RawData'

The above query assumes that the data is in CSV format and stored in a ``RawData`` dataset within the ``hivedoc`` project. More about the different formats supported by Hive and HiveQL can be found in the Hive wiki_.

3. **Convert data in a more storage and computationaly efficient format** : CSV is not the best option when it comes to execute analytic queries. A better format would be ORC which compresses the data and stores it in a columnar oriented format. More about ORC here_.
To convert the data users have to first create a new table::

    create table orc_table (
      street string,
      city string,
      zip int,
      state string,
      beds int,
      baths int,
      sq__ft float,
      sales_type string,
      sale_date string,
      price float,
      latitude float,
      longitude float)
    STORED AS ORC

The above table is a managed table without any specified location, this means that the table data will be managed by Hive and users will be able to access it in the ``projectName.db`` dataset.
More complex data organization can be achieved by partitioning the table by one or multiple columns, or by using the bucketing feature. All the information about these options is available in the Hive wiki_.

The next step is to convert the data from CSV to ORC, to do that users can run the following query::

  insert overwrite table orc_table select * from sales

4. *Query the data*: finally the data is efficiently loaded into Hive and ready to be queried.

.. _here: https://orc.apache.org/


Session based configuration
----------------------------

Hive default configuration cannot be modified by users. What they can do though is change the values of certain configuration parameters for their sessions.
Example: By default Hive is configured to not allow dynamic partitions, this means that the query shown previously at point *3* that inserts the data in the new table **will** fail.
To enable dynamic partitioning we need to set ``hive.exec.dynamic.partition.mode`` to be ``nostrict``.
To do that users can create a new paragraph in the Zeppelin notebook and execute
::

  set hive.exec.dynamic.partition.mode=nostrict

This would enable dynamic partitioning for that session, other users will not be affected by this change and if users launch another ``hopshive`` interpreter they will find the default configuration.

All the parameters that can be set or modified are listed in the Hive wiki under `Tez <https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-Tez>`_. 

Try it out
------------

To try HopsHive out, users can download a sample notebook_ and a csv file_ containing sample data. Users should then create an editable dataset (without README.md) and upload the data.
From the Zeppelin interface, users can import the notebook, by clicking on *Import note* and selecting the Json file representing the notebook from their computers. Before running it, users should modify the LOCATION filled in the first paragraph to be *'/Projects/<projectName>/<datasetName>'* where *<datasetName>* is the name of the dataset containing the csv file.
Users should also make sure to select the HopsHive interpreter by clicking on the gear icon on top and drag the HopsHive box to the top of the list.

.. _notebook: http://snurran.sics.se/hops/hive/sql.json
.. _file: http://snurran.sics.se/hops/hive/Sacramentorealestatetransactions.csv



LLAP Admin
----------------
LLAP stands for *Live long and process*. It's a cluster of long living daemons ready to be used by Hive to read data from the filesystem and to process query fragments.
Hopsworks Admin users have the possibility of managing the lifecycle of the LLAP cluster. They can start and stop the LLAP cluster from the admin UI.
In the admin UI they have the possibility of specifying the number of instances, the amount of memory each instance should get for the LLAP executors running inside the instance, the amount of memory for the cache and how many threads to use for the executors and for the IO.

Normal users can by default use the LLAP cluster in all the projects. By default Hive decides which fragments of the query execute on the LLAP cluster and which in a separate container. Users can change this behavior by changing the session based configuration as explained above.
