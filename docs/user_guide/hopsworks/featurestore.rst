Feature Store
==============

In this tutorial we cover the feature store service in Hopsworks, how it should be used, how it fits into the machine learning pipeline, and the tech-stack behind it.

Feature Store: The Data Management Layer for Machine Learning in Hopsworks
--------------------------------------------------------------------------

The feature store is the central place to store curated features for machine learning pipelines in Hopsworks. A feature is a measurable property of some data-sample. It could be for example an image-pixel, a word from a piece of text, the age of a person, a coordinate emitted from a sensor, or an aggregate value like the average number of purchases within the last hour. Features can come directly from tables or files or can be derived values, computed from one or more data sources.

Features are the fuel for AI systems, as we use them to train machine learning models so that we can make predictions for feature values that we have never seen before. In this tutorial we will see best practices for transforming raw/structured data into *features* that can be included in *training datasets* for training models.

.. _hopsworks_feature_store.png: ../../_images/overview_new.png
.. figure:: ../../imgs/feature_store/overview_new.png
    :alt: A feature store is the interface between feature engineering and model development.
    :target: `hopsworks_feature_store.png`_
    :align: center
    :scale: 55 %
    :figclass: align-center

    A feature store is the interface between feature engineering and model development.

From talking with many organizations that work with data and machine learning, the feature store also has a natural fit in the organizational structure, where it works as an interface between data engineers and data scientists.

*Data Engineers* write features into the feature store. Typically they will (1) read some raw or structured data from a data lake: (2) apply transformations on the data using som data processing framework like Spark; (3) store the transformed feature data in the feature store; (4) add documentation, versioning information, and statistics to the feature data in the feature store.

*Data Scientists* read features from the feature store. A data scientist tend to read features from the feature store for (1) training machine learning models and experimenting with different combination of features; and (2) serving features into machine learning models.

Motivation for the Feature Store
--------------------------------

Machine learning systems have a tendency to assemble technical debt. Examples of technical debt in machine learning systems are:

* There is no principled way to to access features during model serving.
* Features cannot easily be re-used between multiple machine learning pipelines.
* Data science projects work in isolation without collaboration and re-use.
* Features used for training and serving are inconsistent.
* When new data arrives, there is no way to pin down exactly which features need to be recomputed, rather the entire pipeline needs to be run to update features.

Using a feature store is a best practice that can reduce the technical debt of machine learning work-flows. When the feature store is built up with more features, it becomes easier and cheaper to build new models as the new models can re-use features that exist in the feature store. The Feature Store provides, among other things:

* Feature reuse
* Feature discoverability
* Feature backfilling and precomputation
* Improved documentation and analysis of features
* Software engineering principles applied to machine learning features: versioning, documentation, access-control
* Scale; The feature store needs to be able to store and manage huge feature sets (multi-terabyte at least).
* Flexibility; Data scientists must be able to read from the feature store and use the data in different machine learning frameworks, like Tensorflow, Keras, Scikit learn, and PyTorch.
* Analysis; Data scientists need an understanding of the feature data to be able to make most use of it in their models. They should be able to analyze the features, view their distributions over time, their correlations with each other etc.
* Point-in-time correctness; It can be valuable to be able to extract the value of a feature at a specific point-in-time to be able to later on change the value of the feature.
* Real-time; for client-facing models, features must be available in real-time (< 10ms) for making predictions to avoid destroying the user-experience for the user.
* Online/Offline Consistency; when a feature is used for both training and serving, and stored in two different storage layers, you want to make sure that the value and semantics of the feature is consistent.

How to Use the Feature Store
----------------------------

When adopting the feature store in your machine learning work-flows, you can think of it as the interface between data engineering and data science. It has two APIs, one for writing to the feature store and one for reading features. At the end of your data engineering pipeline, instead of writing features to a custom storage location, write the features to the feature store and get benefits such as automatic documentation, versioning, feature analysis, and feature sharing. As a data scientist, when you start a new machine learning project, you can search through the feature store for available features and only add new features if they do not already exist in the feature store. We encourage to reuse features as much as possible to avoid doing unnecessary work and to make features consistent between different models.

Creating a Project on Hopsworks with The Feature Store Service Enabled
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To create a project with the feature store service, mark the check-box available when you create a new project in Hopsworks.

.. _featurestore_create_project.png: ../../_images/create_project.png
.. figure:: ../../imgs/feature_store/create_project.png
    :alt: Create a new project with the feature store service enabled.
    :target: `featurestore_create_project.png`_
    :align: center
    :figclass: align-center

    Create a new project with the feature store service enabled.

Inside the project you can find the feature registry (where all the feature store data is browsable) in the feature store page that is accessible by clicking the feature store icon on the left.

.. _featurestore_open_registry.png: ../../_images/opening_feature_registry.png
.. figure:: ../../imgs/feature_store/opening_feature_registry.png
    :alt: Opening the feature store registry
    :target: `featurestore_open_registry.png`_
    :align: center
    :figclass: align-center

    Opening the feature store registry in Hopsworks.

Data Modeling in the Feature Store
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We introduce three new concepts to our users for modeling data in the feature store.

* The **feature** is an individual versioned and documented data column in the feature store, e.g the average rating of a customer.
* The **feature group** is a documented and versioned group of features stored as a Hive table. The feature group is linked to a specific Spark/Numpy/Pandas job that takes in raw data and outputs the computed features.
* The **training dataset** is a versioned and managed dataset of features and labels (potentially from multiple different feature groups). Training datasets are stored in HopsFS as tfrecords, parquet, csv, or tsv files.

.. _featurestore_concepts.png: ../../_images/concepts.png
.. figure:: ../../imgs/feature_store/concepts.png
    :alt: Feature Store API
    :target: `featurestore_concepts.png`_
    :align: center
    :figclass: align-center

    Concepts for modeling data in the feature store.

The API
~~~~~~~

The feature store in Hopsworks has a REST API that is accessible with any REST-client, or with the provided Python Scala/Java SDKs. This section gives an overview of the API and how to work with either the Python SDK or the Scala/Java SDK. We will show examples of the most common API methods. To get a full overview of the API please see the API-Docs-Python_, API-Docs-Scala_ and the featurestore_example_notebooks_.

**Creating New Features**

The feature store is agnostic to the method for computing the features. The only requirement is that the features can be grouped together in a Pandas, Numpy, or Spark dataframe. The user provides a dataframe with features and associated feature metadata (metadata can also be edited later through the feature registry UI) and the feature store library takes care of creating a new version of the feature group, computing feature statistics and linking the features to the job to compute them.

* Inserting into an existing feature group using the Python API:

.. code-block:: python

    from hops import featurestore
    featurestore.insert_into_featuregroup(features_df, featuregroup_name)

* Inserting into an existing feature group using the Scala/Java API:

.. code-block:: scala

    import io.hops.util.Hops
    Hops.insertIntoFeaturegroup(featuregroupName).setDataframe(sampleDF).setMode("append").write()

* Creating a new feature group using the Python API:

.. code-block:: python

    from hops import featurestore
    featurestore.create_featuregroup(features_df, featuregroup_name)

* Creating a new feature group using the Scala/Java API:

.. code-block:: scala

    import io.hops.util.Hops
    Hops.createFeaturegroup(featuregroupName).setDataframe(featuresDf).write()

**Reading From the Feature Store**

To read features from the feature store, users can use either SQL directly or the API-functions available in Python and Scala. Based on our experience with users on our platform, data scientists can have diverse backgrounds. Although some data scientists are very comfortable with SQL, others prefer higher level APIs. This motivated us to develop a query-planner to simplify user queries. The query-planner enables users to express the bare minimum information to fetch features from the feature store. For example, a user can request 100 features that are spread across 20 different feature groups by just providing a list of feature names. The query planner uses the metadata in the feature store to infer where to fetch the features from and how to join them together.

.. _featurestore_query_planner.png: ../../_images/query_optimizer.png
.. figure:: ../../imgs/feature_store/query_optimizer.png
    :alt: Feature Store Query Planner
    :target: `featurestore_query_planner.png`_
    :align: center
    :figclass: align-center

    Users query the feature store programmatically or using SQL. The output is provided as Pandas, Numpy or Spark dataframes.

For example, to fetch the features `average_attendance` and `average_player_age` from the feature store, all the user has to write is:

.. code-block:: python

    from hops import featurestore
    features_df = featurestore.get_features(["average_attendance", "average_player_age"])

and using the Scala/Java API:

.. code-block:: scala

    import io.hops.util.Hops
    val features_df = Hops.getFeatures(List("average_attendance", "average_player_age")).read()

**Creating Training Datasets**

Organizations typically have many different types of raw datasets that can be used to extract features. For example, in the context of user recommendation there might be one dataset with demographic data of users and another dataset with user activities. Features from the same dataset are naturally grouped into a feature group, producing one feature group per dataset. When training a model, you want to include all features that have predictive power for the prediction task, these features can potentially span multiple feature groups. The training dataset abstraction in Hopsworks Feature Store is used for this purpose, allowing users to group a set of features with labels for training a model to do a particular prediction task.

Once a user has fetched a set of features from different feature groups in the feature store, the features can be materialized into a training dataset. By creating a training dataset using the feature store API, the dataset becomes managed by the feature store. Managed training datasets are automatically analyzed for data anomalies, versioned, documented, and shared with the rest of the organization.

.. _featurestore_pipeline.png: ../../_images/pipeline.png
.. figure:: ../../imgs/feature_store/pipeline.png
    :alt: Feature Store Pipeline
    :target: `featurestore_pipeline.png`_
    :align: center
    :figclass: align-center

    The life-cycle of data in HopsML. Raw data is transformed into features which are grouped together into training datasets that are used to train models.

To create a managed training dataset, the user supplies a Pandas, Numpy or Spark dataframe with features and labels together with metadata.

* Creating a training dataset using the Python API:

.. code-block:: python

    from hops import featurestore
    featurestore.create_training_dataset(features_df,training_dataset_name,data_format="tfrecords")

* Creating a training dataset using the Scala/Java API:

.. code-block:: scala

    import io.hops.util.Hops
    Hops.createTrainingDataset(training_dataset_name).setDataframe(featuresDf).setDataFormat("tfrecords").write()


**Reading a Training Dataset for Training a Model**:

Once the training dataset has been created, the dataset is discoverable in the feature registry and users can use it to train models. Below is an example code snippet for training a model using a training dataset stored distributed in the tfrecords format on HopsFS.

* Using the Python API:

.. code-block:: python

    from hops import featurestore
    import tensorflow as tf
    dataset_dir = featurestore.get_training_dataset_path(td_name)
    # the tf records are written in a distributed manner using partitions
    input_files = tf.gfile.Glob(dataset_dir + "/part-r-*")
    # tf record schemas are managed by the feature store
    tf_record_schema = featurestore.get_training_dataset_tf_record_schema(td_name)
    def decode(example_proto):
        return tf.parse_single_example(example_proto, tf_record_schema)

    dataset = tf.data.TFRecordDataset(input_files)
                                 .map(decode)
                                 .shuffle(shuffle_buffer_size)
                                 .batch(batch_size)
                                 .repeat(num_epochs)
    # three layer MLP for regression
    model = tf.keras.Sequential([
           layers.Dense(64, activation="relu"),
           layers.Dense(64, activation="relu"),
           layers.Dense(1)
        ])
    model.compile(optimizer=tf.train.AdamOptimizer(lr), loss="mse")
    model.fit(dataset, epochs=num_epochs, steps_per_epoch=spe)


* Using the Scala/Java API:

.. code-block:: scala

    import io.hops.util.Hops
    val dataset_df = Hops.getTrainingDataset("team_position_prediction").read()
    val transformedDf = new VectorAssembler().setInputCols(Array( "average_player_rating","average_attendance", "sum_player_rating",
                     "sum_position", "sum_player_worth", "average_player_age", "average_player_worth",
                     "team_budget", "average_position", "sum_player_age", "sum_attendance")).
		     setOutputCol("features").
		     transform(dataset_df).
		     drop("average_player_rating").
		     drop("average_attendance").
		     drop("sum_player_rating").
		     drop("sum_player_worth").
		     drop("average_player_age").
		     drop("average_player_worth").
		     drop("team_budget").
		     drop("average_position").
		     drop("sum_player_age").
		     drop("sum_attendance").
		     drop("sum_position")
    val lr = new LinearRegression().
    setLabelCol("team_position").
    setFeaturesCol("features").
    setMaxIter(NUM_ITER).
    setRegParam(REG_LAMBDA_PARAM).
    setElasticNetParam(ELASTIC_REG_PARAM)
    val lrModel = lr.fit(transformedDf)
    lrModel.transform(transformedDf).select("features", "team_position", "prediction").show()
    val trainingSummary = lrModel.summary
    println(s"numIterations: ${trainingSummary.totalIterations}")
    println(s"objectiveHistory: [${trainingSummary.objectiveHistory.mkString(",")}]")
    trainingSummary.residuals.show()
    println(s"RMSE: ${trainingSummary.rootMeanSquaredError}")
    println(s"r2: ${trainingSummary.r2}")



The Feature Registry
~~~~~~~~~~~~~~~~~~~~

The feature registry is the user interface for publishing and discovering features and training datasets. The feature registry also serves as a tool for analyzing feature evolution over time by comparing feature versions. When a new data science project is started, data scientists within the project typically begin by scanning the feature registry for available features, and only add new features for their model that do not already exist in the feature store.

The feature registry provides:

* Keyword search on feature/feature group/training dataset metadata.
* Create/Update/Delete/View operations on feature/feature group/training dataset metadata.
* Automatic feature analysis.
* Feature dependency/provenance tracking.
* Feature job tracking.

**Finding Features**

In the registry you can search for features, feature groups and training datasets in the search bar. Features are automatically grouped by versions in the search results.

.. _hopsworks_featurestore_finding_features.png: ../../_images/finding_features.png
.. figure:: ../../imgs/feature_store/finding_features.png
    :alt: Searching for features in the feature registry.
    :target: `hopsworks_featurestore_finding_features.png`_
    :align: center
    :figclass: align-center

    Searching for features in the feature registry.

**Automatic Feature Analysis**

When a feature group or training dataset is updated in the feature store, a data analysis step is performed. In particular, we look at cluster analysis, feature correlation, feature histograms and descriptive statistics. We have found that these are the most common type of statistics that our users find useful in the feature modeling phase. For example, feature correlation information can be used to identify redundant features, feature histograms can be used to monitor feature distributions between different versions of a feature to discover covariate shift, and cluster analysis can be used to spot outliers. Having such statistics accessible in the feature registry helps data scientists decide on which features to use.

.. _hopsworks_featurestore_opening_stats_tab.png: ../../_images/opening_stats_tab.png
.. figure:: ../../imgs/feature_store/opening_stats_tab.png
    :alt: Searching for features in the feature registry.
    :target: `hopsworks_featurestore_opening_stats_tab.png`_
    :align: center
    :scale: 55 %
    :figclass: align-center

    Opening that statistics for a feature group.

**Other Actions Available in the Feature Registry**

A common practice using the feature store is that the data of feature groups and training datasets are inserted using the APIs in Python/Java/Scala, but the metadata is filled and edited from the feature registry UI. In addition to editing metadata about features, the registry also provides the following functionality:

* Create/Update/Delete operations on feature groups and training datasets
* Preview feature group data
* View feature group and training dataset schemas
* Create new Training Datasets by grouping features together
* Configuring storage connectors

On-Demand and Cached Features
------------------------------------

There are two types of feature groups in the Feature Store:

* **Cached Feature Group**: This type of feature group is the most common, it will store the computed features inside the Hopsworks Feature Store.
* **On-Demand Feature Groups**: This type of feature group is not stored in Hopsworks, rather it is computed *on-demand*. To create an on-demand feature group you must configure a JDBC connector and a SQL query to compute the features. On-demand feature groups are typically used when an organization have feature data available in external storage systems and don't want to duplicate the data in Hopsworks feature store.

The code-snippets below illustrates the different APIs for creating a cached vs an on-demand feature group using the Scala SDK:

.. code-block:: scala

    //Cached Feature Group
    Hops.createFeaturegroup(fgName).setDataframe(df).write()

    //On-Demand Feature Group
    Hops.createFeaturegroup(fgName).setOnDemand(true).setJdbcConnector(sc).setSqlQuery(query).write()


Online and Offline Feature Groups
---------------------------------

To explain the need for the separation into online and offline features, it is useful to review the use-cases of the feature store. The feature store has a natural fit in the machine learning workflow. The feature store works as an interface between data engineers and data scientists.

- **Data Engineers** write features into the feature store. Typically they will (1) read some raw or structured data from a data lake: (2) apply transformations on the data using som data processing framework like Spark; (3) store the transformed feature data in the feature store; (4) add documentation, versioning information, and statistics to the feature data in the feature store.
- **Data Scientists** tend to read features from the feature store for (1) training machine learning models and experimenting with different combination of features; and (2) serving features into machine learning models. These two-use cases of the feature store has very different characteristics, motivating the need for a separation between *online* store of features and an *offline* store of features.

When reading from the feature store for training/experimentation, there are requirements on the feature store such as

- **Scale**; The feature store needs to be able to store and manage huge feature sets (multi-terabyte at least).
- **Flexibility**; Data scientists must be able to read from the feature store and use the data in different machine learning frameworks, like Tensorflow, Keras, Scikit learn, and PyTorch.
- **Analysis**; Data scientists need an understanding of the feature data to be able to make most use of it in their models. They should be able to analyze the features, view their distributions over time, their correlations with each other etc.
- **Point-in-time correctness**; It can be valuable to be able to extract the value of a feature at a specific point-in-time to be able to later on change the value of the feature. For example, say that we at point in time X have a feature-vector for customer C1, and at time X we don’t know that C1 is doing fraud, so the label of C1 is “benign customer”. Later on at time Y we find out that customer C1 actually was taking part in fraudulent activity at time X. Then we want to be able to go back and modify the label of C1 to “malign customer” and re-train our model or re-evaluate the model. I.e it should be possible to re-create old training data from future predictions. Ideally, this point-in-time correctness of a feature should be possible without having to store the value of a feature at every single point in time, rather it should be possible to re-compute the value of a feature at a specific point in time dynamically.

On the other hand, when reading from the feature store for serving models there are very specific requirements that differ from the requirements for training/serving:

- **Real-time**; for client-facing models, features must be available in real-time for making predictions to avoid destroying the user-experience for the user. The limits for what is considered real-time depends on the context. Hopsworks feature store can serve features in < 5 ms.
- **Online/Offline Consistency**; when a feature is used for both training and serving, and stored in two different storage layers, you want to make sure that the value and semantics of the feature is consistent. Offline/online consistency has a lot to do with that you have to rewrite code between train and serving, if you can use the same code for both, then a lot is solved as the transformation to compute the feature happens before it gets to the feature store, if the code for computing the feature is consistent between training/serving you can store the feature data in two different storage layers for training/serving and still be confident in its consistency. However, if you have to rewrite the pipeline to compute batch features to a new pipeline for computing online features, you might get consistency issues. The data that you give the model during serving has to look exactly the same as the data you train the model with, otherwise your model will behave weird and bad.

Due to the very different requirements on batch and real-time features, it is common to split the feature store into two parts, a batch feature store for storing features for training and a real-time feature store for storing features for serving. In Hopsworks we store offline feature data in **Hive** and online feature data in **MySQL Cluster**.


.. _hopsworks_online_featurestore.png: ../../_images/online_featurestore.png
.. figure:: ../../imgs/feature_store/online_featurestore.png
    :alt: Hopsworks Feature Store Architecture. Online features are stored in MySQL Cluster and Offline Features are stored in Hive
    :target: `hopsworks_online_featurestore.png`_
    :align: center
    :figclass: align-center

    Hopsworks Feature Store Architecture. Online features are stored in MySQL Cluster and Offline Features are stored in Hive.

The feature store service on Hopsworks unifies the Online/Offline feature data under a single API, making the underlying infrastructure transparent to the data scientist.

.. _hopsworks_online_featurestore2.png: ../../_images/online_featurestore2.png
.. figure:: ../../imgs/feature_store/online_featurestore2.png
    :alt: Data is typically ingested into the Feature Store through Kafka and historical data is stored in the offline feature store (Hive) and recent data for online-serving is stored in the online feature store (MySQL Cluster). The feature store provides connectors to common ML frameworks and platforms.
    :target: `hopsworks_online_featurestore2.png`_
    :align: center
    :figclass: align-center

    Data is typically ingested into the Feature Store through Kafka and historical data is stored in the offline feature store (Hive) and recent data for online-serving is stored in the online feature store (MySQL Cluster). The feature store provides connectors to common ML frameworks and platforms.

The code-snippets below illustrates the different APIs for creating feature groups with online/offline storage enabled:

.. code-block:: python

    from hops import featurestore

    # create feature group and insert data only in the online storage
    featurestore.create_featuregroup(spark_df, featuregroup_name, online=True, primary_key="id")

    # create feature group and insert data only in the offline storage
    featurestore.create_featuregroup(spark_df, featuregroup_name, online=False, offline=True, primary_key="id")

    # create feature group and insert data in both the online and the offline storage
    featurestore.create_featuregroup(spark_df, featuregroup_name, online=True, offline=True, primary_key="id")

    # insert into an existing online feature group
    featurestore.insert_into_featuregroup(sample_df, "online_featuregroup_test", online=True, offline=False, mode="append")

    # insert into an existing offline feature group
    featurestore.insert_into_featuregroup(sample_df, "online_featuregroup_test", online=False, offline=True, mode="append")

    # insert into an existing online & offline feature group
    featurestore.insert_into_featuregroup(sample_df, "online_featuregroup_test", online=True, offline=True, mode="append")

The same methods for reading the offline feature store can be used to read from the online feature store by setting the argument `online=True`. However, please note that as the online feature store is supposed to be used for feature serving, it should be queried with primary-key lookups for getting the best performance. In fact, it is highly discouraged to use the online feature serving for doing full-table-scans. If you find yourself frequently needing to use `get_featuregroup(online=True)` to get the entire feature group (full-table scan), you are probably better of using the offline feature store. The online feature store is intended for quick primary key lookups, not data analysis. The code-snippets below illustrates the different APIs for reading from the online/offline feature store.

.. code-block:: python

    from hops import featurestore

    # primary key lookup in the online feature store using SQL
    df = featurestore.sql("SELECT feature FROM featuregroup_name WHERE primary_key=x", online=True)

    # read all values of a given featuregroup in the online featurestore
    df = featurestore.get_featuregroup(featuregroup_name, online=True)

    # read all values of a given feature in the online featurestore
    df = featurestore.get_feature(feature_name, online=True)

More examples of using feature store Python and Scala SDK to read/write from/to the online feature store are available at featurestore_example_notebooks_.

External and HopsFS Training Datasets
-------------------------------------

There are two storage types for training datasets in the Feature Store:

* **HopsFS**: The default storage type for training datasets is HopsFS, a state-of-the-art scalable file system that comes bundled with the Hopsworks stack.
* **S3**: The feature store SDKs also provides the functionality to store training datasets external to a Hopsworks installation, e.g in S3. When training datasets are stored in S3, only the metadata is managed in Hopsworks and the actual data is stored in S3. To be able to create external training datasets, you must first configure a storage connector to S3.

The code-snippets below illustrates the different APIs for creating a training dataset stored in HopsFS vs a training dataset stored in S3, using the Scala SDK:

.. code-block:: scala

    //Training Dataset stored in HopsFS (default sink)
    Hops.createTrainingDataset(tdName).setDataframe(df).write()

    //External Training Dataset
    Hops.createTrainingDataset(tdName).setDataframe(df).setSink(s3Connector).write()


Configuring Storage Connectors for the Feature Store
----------------------------------------------------

By default, a feature store created in Hopsworks will have three storage connectors:

- `projectname`, a JDBC connector for the project's general-purpose Hive database
- `projectname_featurestore`, a JDBC connector for the project's feature store database (this is where cached feature groups are stored)
- `projectname_Training_Datasets`, a HopsFS connector for storing training datasets inside the project

To configure new storage connectors, e.g S3, HopsFS, or JDBC connectors, use the form available in the feature registry UI.

.. _hopsworks_featurestore_new_sc.png: ../../_images/new_sc.png
.. figure:: ../../imgs/feature_store/new_sc.png
    :alt: New storage connectors can be configured from the Feature Store UI.
    :target: `hopsworks_featurestore_new_sc.png`_
    :align: center
    :scale: 55 %
    :figclass: align-center

    Storage Connectors can be configured from the Feature Store UI in Hopsworks.


Incremental Ingestion to the Feature Store using Apache Hudi
------------------------------------------------------------

Hopsworks Feature Store supports Apache Hudi (hudi_) for efficient upserts and time-travel in the feature store. Below is a code-snippet illustrating how to use Hudi when inserting into feature groups and for time-travel.

.. code-block:: scala

    import io.hops.util.Hops
    Hops.createFeaturegroup(featuregroup_name)
                         .setHudi(true)
                         .setPartitionBy(partitionCols)
                         .setDataframe(sparkDf)
                         .setPrimaryKey(primaryKeyName).write()

    Hops.queryFeaturestore("SELECT id, value FROM featuregroup_name WHERE _hoodie_commit_time = X").read.show(5)

A Multi-tenant Feature Store Service
------------------------------------

Despite the benefit of centralizing features, we have identified a need to enforce access control to features. Several organizations that we have talked to are working partially with sensitive data that requires specific access rights that is not granted to everyone in the organization. For example, it might not be feasible to publish features that are extracted from sensitive data to a feature store that is public within the organization.

To solve this problem we utilize the multi-tenant model of Hopsworks. Feature stores in Hopsworks are by default project-private and can be shared across projects, which means that an organization can combine public and private feature stores. An organization can have a central public feature store that is shared with everyone in the organization as well as private feature stores containing features of sensitive nature that are only accessible by users with the appropriate permissions.

.. _hopsworks_featurestore_multitenant.png: ../../_images/multitenant.png
.. figure:: ../../imgs/feature_store/multitenant.png
    :alt: Based on the organization need, features can be divided into several feature stores to preserve data access control.
    :target: `hopsworks_featurestore_multitenant.png`_
    :align: center
    :scale: 55 %
    :figclass: align-center

    Based on the organization need, features can be divided into several feature stores to preserve data access control.

To share a feature store with another project, share the dataset containing the feature groups and features (**projectname_featurestore.db**) as well as the dataset that contains the training datasets (**projectname_Training_Datasets**). To share datasets in Hopsworks simply right-click the feature store inside of your project dataset browser:

.. _hopsworks_featurestore_share_fs.png: ../../_images/share_fs.png
.. figure:: ../../imgs/feature_store/share_fs.png
    :alt: Feature stores can be shared across project boundaries.
    :target: `hopsworks_featurestore_share_fs.png`_
    :align: center
    :scale: 55 %
    :figclass: align-center

    Feature stores can be shared across project boundaries.


When you have multiple feature stores shared with your project you can select which one to view in the feature registry:

.. _hopsworks_featurestore_select_fs.png: ../../_images/select_fs.png
.. figure:: ../../imgs/feature_store/select_fs.png
    :alt: Select feature store in the feature registry
    :target: `hopsworks_featurestore_select_fs.png`_
    :align: center
    :scale: 55 %
    :figclass: align-center

    Selecting a feature store in the feature registry.

Technical Details on the Architecture
-------------------------------------

The architecture of the feature store in hopsworks is depicted in the image below.

.. _hopsworks_featurestore_architecture.png: ../../_images/arch_w_pandas_numpy.png
.. figure:: ../../imgs/feature_store/arch_w_pandas_numpy.png
    :alt: Hopsworks feature store architecture
    :target: `hopsworks_featurestore_architecture.png`_
    :align: center
    :scale: 55 %
    :figclass: align-center

    Architecture of Hops Feature Store.


A feature store consists of five main components:

* The feature engineering jobs, the jobs used to compute the features and insert into the feature store.
* The storage layer for storing the feature data.
* The metadata layer used for storing code to compute features, versioning, analysis data, and documentation.
* The API, used for reading/writing features from/to the feature store.
* The feature registry, a user interface (UI) service where data scientists can share, discover, and order computation of features.


.. _hopsworks_featurestore_stack.png: ../../_images/fs_stack.png
.. figure:: ../../imgs/feature_store/fs_stack.png
    :alt: Hopsworks feature store components
    :target: `hopsworks_featurestore_stack.png`_
    :align: center
    :scale: 85 %
    :figclass: align-center

    Feature Store Component Hierarchy.

Connecting from Amazon SageMaker
--------------------------------
Connecting to the Feature Store from Amazon SageMaker requires a Feature Store API key to be stored in the AWS Secrets Manager or Parameter Store. Additionally, read access to this API key needs to be given to the AWS role used by SageMaker and hops-util-py needs to be installed on SageMaker.

**Generating an API Key and storing it in the AWS Secrets Manager**

In Hopsworks, click on your username in the top-right corner and select *Settings* to open the user settings. Select *Api keys*. Give the key a name and select the *featurestore* and *project* scopes before creating the key. Copy the key into your clipboard for the next step.

.. _hopsworks_api_key.png: ../../_images/api_key.png
.. figure:: ../../imgs/feature_store/api_key.png
    :alt: Hopsworks feature store api key
    :target: `hopsworks_api_key.png`_
    :align: center
    :scale: 30 %
    :figclass: align-center

**(Alternative 1) Storing the API Key in the AWS Secrets Manager**

In the AWS management console ensure that your active region is the region you use for SageMaker. Go to the *AWS Secrets Manager* and select *Store new secret*. Select *Other type of secrets* and add *api-key* as the key and paste the API key created in the previous step as the value. Click next.

.. _hopsworks_secrets_manager.png: ../../_images/secrets_manager.png
.. figure:: ../../imgs/feature_store/secrets_manager.png
    :alt: Hopsworks feature store secrets manager step 1
    :target: `hopsworks_secrets_manager.png`_
    :align: center
    :scale: 20 %
    :figclass: align-center

As secret name enter *hopsworks/project/[MY_HOPSWORKS_PROJECT]/role/[MY_SAGEMAKER_ROLE]* replacing [MY_HOPSWORKS_PROJECT] with the name of the project hosting the Feature Store in Hopsworks and [MY_SAGEMAKER_ROLE] with the AWS role used by the SageMaker instance that should access the Feature Store. Select next twice and finally store the secret. Then click on the secret in the secrets list and take note of the *Secret ARN*.

.. _hopsworks_secrets_manager2.png: ../../_images/secrets_manager2.png
.. figure:: ../../imgs/feature_store/secrets_manager2.png
    :alt: Hopsworks feature store secrets manager step 2
    :target: `hopsworks_secrets_manager2.png`_
    :align: center
    :scale: 20 %
    :figclass: align-center

**(Alternative 1) Granting access to the secret to the SageMaker notebook role**

In the AWS management console go to *IAM*, select *Roles* and then the role that is used when creating SageMaker notebook instances. Select *Add inline policy*. Choose *Secrets Manager* as service, expand the *Read* access level and check *GetSecretValue*. Expand Resources and select *Add ARN*. Paste the ARN of the secret created in the previous step. Click on *Review*, give the policy a name und click on *Create policy*.

.. _hopsworks_aws_policy.png: ../../_images/aws_policy.png
.. figure:: ../../imgs/feature_store/aws_policy.png
    :alt: Hopsworks feature store set policy
    :target: `hopsworks_aws_policy.png`_
    :align: center
    :scale: 20 %
    :figclass: align-center

**(Alternative 2) Storing the API Key in the AWS Systems Manager Parameter Store**

In the AWS management console ensure that your active region is the region you use for SageMaker. Go to the *AWS Systems Manager* choose *Parameter Store* and select *Create Parameter*. As name enter */hopsworks/project/[MY_HOPSWORKS_PROJECT]/role/[MY_SAGEMAKER_ROLE]/type/api-key* replacing [MY_HOPSWORKS_PROJECT] with the name of the project hosting the Feature Store in Hopsworks and [MY_SAGEMAKER_ROLE] with the AWS role used by the SageMaker instance that should access the Feature Store. Select *Secure String* as type and create the parameter.

.. _hopsworks_parameter_store.png: ../../_images/parameter_store.png
.. figure:: ../../imgs/feature_store/parameter_store.png
    :alt: Hopsworks feature store parameter store
    :target: `hopsworks_parameter_store.png`_
    :align: center
    :scale: 20 %
    :figclass: align-center

**(Alternative 2) Granting access to the secret to the SageMaker notebook role**

In the AWS management console go to *IAM*, select *Roles* and then the role that is used when creating SageMaker notebook instances. Select *Add inline policy*. Choose *Systems Manager* as service, expand the *Read* access level and check *GetParameter*. Expand Resources and select *Add ARN*. Fill in the region of the *Systems Manager* as well as the name of the parameter **WITHOUT the leading slash** e.g. *hopsworks/project/[MY_HOPSWORKS_PROJECT]/role/[MY_SAGEMAKER_ROLE]/type/api-key* and click *Add*. Click on *Review*, give the policy a name und click on *Create policy*.

.. _hopsworks_aws_policy2.png: ../../_images/aws_policy2.png
.. figure:: ../../imgs/feature_store/aws_policy2.png
    :alt: Hopsworks feature store set policy
    :target: `hopsworks_aws_policy2.png`_
    :align: center
    :scale: 30 %
    :figclass: align-center

**Installing hopsworks-cloud-sdk and connecting to the Feature Store**

To be able to access the Hopsworks Feature Store, the hopsworks-cloud-sdk library needs to be installed. One way of achieving this is by opening a Python notebook in SageMaker and installing the latest hopsworks-cloud-sdk. Note that the library will not be persistent. For information around how to permanently install a library to Sagemaker see `Install External Libraries and Kernels in Notebook Instances <https://docs.aws.amazon.com/sagemaker/latest/dg/nbi-add-external.html>`_. ::

    !pip install hopsworks-cloud-sdk

You can now connect to the Feature Store::

    import hops.featurestore as fs
    fs.connect('my_instance.us-east-2.compute.amazonaws.com', 'my_project', secrets_store = 'secretsmanager')

If you have trouble connecting, then ensure that the Security Group of your Hopsworks instance on AWS is configured to allow incoming traffic from your SageMaker instance. See `VPC Security Groups <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html>`_. for more information. If your Sagemaker instances are not in the same VPC as your Hopsworks instance and the Hopsworks instance is not accessible from the internet then you will need to configure `VPC Peering on AWS <https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html>`_.

Connecting from Databricks notebooks
------------------------------------

**Setting up roles and API keys**

Follow the steps descibed in `Connecting from Amazon SageMaker`_ for setting up Hopsworks API keys and AWS roles and access to secrets. Ensure to use the role that is specified in the *Advanced Options* when creating a Spark cluster in Databricks.

**Installing hopsworks-cloud-sdk**

The feature store library needs to be installed to connect to it. In the Databricks UI, go to *Clusters* and select your cluster. Select *Libraries* and then *Install New*. As *Library Source* choose *PyPI* and fill in *hopsworks-cloud-sdk* into the *Package* field. Additionally, you'll need to upgrade the *boto3* library to be able to read secrets from the *AWS Secrets Manger*. Do so by repeating the process with the package *boto3==1.9.227*.

**Connecting to the Feature Store**

In the Databricks notebooks connected to the prepared cluster use the following code to connect to the feature store::

    import hops.featurestore as fs
    fs.connect('my_instance.us-east-2.compute.amazonaws.com', 'my_project', secrets_store = 'secretsmanager')

If you have trouble connecting, then ensure that the Security Group of your Hopsworks instance on AWS is configured to allow incoming traffic from your SageMaker instance. See `VPC Security Groups <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html>`_. for more information. If the Hopsworks instance is not accessible from the internet then you will need to configure `VPC Peering <https://docs.databricks.com/administration-guide/cloud-configurations/aws/vpc-peering.html>`_.

Want to Learn More?
-------------------

We have provided a large number of example notebooks, available here_. Go to Hopsworks and try them out! You can do this either by taking one of the built-in *tours* on Hopsworks, or by uploading one of the example notebooks to your project and run it through the Jupyter service. You can also have a look at HopsML_, which enables large-scale distributed deep learning on Hops.

.. _here: https://github.com/logicalclocks/hops-examples
.. _HopsML: ../../hopsml/hopsML.html
.. _jobs: ./jobs.html
.. _featurestore_example_notebooks: https://github.com/Limmen/hops-examples/tree/HOPSWORKS-721/notebooks/featurestore
.. _API-Docs-Python: http://hops-py.logicalclocks.com/
.. _API-Docs-Scala: http://snurran.sics.se/hops/hops-util-javadoc/
.. _hudi: http://hudi.apache.org/
