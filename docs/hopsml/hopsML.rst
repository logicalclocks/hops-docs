HopsML
======

Python-First ML Pipelines
------------

.. _hopsml-pipeline.png: ../_images/hopsml-pipeline.png
.. figure:: ../imgs/hopsml-pipeline.png
    :alt: HopsML Pipeline
    :target: `hopsml-pipeline.png`_
    :align: center
    :scale: 50%	   
    :figclass: align-center



	       
.. _hopsml-hopsfs-pipeline.png: ../_images/hopsml-hopsfs-pipeline.png
.. figure:: ../imgs/hopsml-hopsfs-pipeline.png
    :alt: HopsML Pipeline with HopsFS
    :target: `hopsml-hopsfs-pipeline.png`_
    :align: center
    :scale: 50%
    :figclass: align-center


	       
Hops Python Library
-------------------

The Hops Python Library simply named *hops* is used for running Python applications and consequently a library which is used throughout the entire pipeline. It simplifies interacting with services such as Kafka, Model Serving and TensorBoard. The experiment module provides a rich API for running versioned Machine Learning experiments, whether it be a simple single-process Python application or RingAllReduce over many machines.

Documentation: hops-py_ 

Code examples: hops-examples_ 

Data Collection
---------------

The datasets that you are working with will reside in your project in HopsFS. Data can be uploaded to your project in a number of ways, such as using the hops-cli client, the REST API or the uploader in the Hopsworks UI. HopsFS is the filesystem of Hops, it is essentially an optimized fork of Apache HDFS, and is compliant with any API that can read data from an HDFS path, such as TensorFlow, Spark and Pandas.

Data Transformation & Verification
----------------------------------

It is important to validate the datasets used in your pipeline, for example imbalanced classes may lead to Machine Learning models being biased towards more frequently occurring labels in the dataset.  Therefore it is of outmost importance for input data to be balanced and representative of the domain from which the data came. One of the big steps toward ensuring the correctness of data is through data quality and validation checks. Machine Learning models, as have been observed empirically and in papers_, reduce their generalization error for larger datasets. Therefore it is also critical to have a data wrangling and validation engine which scales for ever increasing datasets. The solution for this is to go distributed in order to process every single record, but still have a rich API for perform quality checks and manipulating the data. The pipeline makes use of Spark to provide these capabilities.

Spark Dataframes can be used to transform and validate large datasets in a distributed manner. For example schemas can be used to validate the datasets. Useful insights can be calculated such as class imbalance, null values for fields and making sure values are inside certain ranges. Datasets can be transformed by dropping or filtering fields.

For visualizations on datasets, see spark-magic_ or facets_ examples here. 

Feature Extraction
------------------

This part of the pipeline is still in development. The plan is to release a Feature Store.


Experimentation
---------------

This section will give an overview of running Machine Learning experiments on Hops.

In HopsML we offer a rich experiment_ API for data scientists to run their Machine Learning code, whether it be TensorFlow, Keras PyTorch or another framework with a Python API. To mention some of features it provides versioning of notebooks and other resources, AutoML algorithms that will find the best hyperparameters for your model and managing TensorBoard.

Hops uses PySpark to manage resource allocation of CPU, Memory and GPUs. PySpark is also used to transparently distribute the Python code making up the experiment to Executors which executes it. Certain hyperparameter optimization algorithms such as random search and grid search are parallelizable by nature, which means that different Executors will run different hyperparameter combinations. If a particular Executor sits idle it will be reclaimed by the cluster, which means that GPUs will be optimally used in the cluster. This is made possible by Dynamic Spark Executors.


.. _pyspark_tf.png: ../_images/pyspark_tf.png
.. figure:: ../imgs/pyspark_tf.png
    :alt: Increasing throughput
    :target: `pyspark_tf.png`_
    :align: center
    :figclass: align-center


Hops supports cluster-wide Conda for managing Python library dependencies. Hops supports the creation of projects, and each project has its own conda environment, replicated at all hosts in the cluster. When you launch a PySpark job, it uses the local conda environment for that project. This way, users can install whatever libraries they like using conda and pip package managers, and then use them directly inside Spark Executors. It makes programming PySpark one step closer to the single-host experience of programming Python.



HopsML comes with a novel Experiments service for overviewing history of Machine Learning experiments.


.. _tensorboard.png: ../_images/tensorboard.png
.. figure:: ../imgs/tensorboard.png
    :alt: TensorBoard
    :target: `tensorboard.png`_
    :align: center
    :figclass: align-center


See experiments_ for more information.

See jupyter_ for development using Jupyter notebooks.

Serving
-------

In the pipeline we support a scalable architecture for serving of TensorFlow and Keras models. We use the TensorFlow Serving server running on Kubernetes to scale up the number of serving instances dynamically and handle load balancing. There is support for using either the grpc client or the REST API to send inference requests. Furthermore we also support a monitoring system that logs the inference requests and allows users to implement custom functionality for retraining of models.

.. _serving_architecture.png: ../_images/serving_architecture.png
.. figure:: ../imgs/serving_architecture.png
    :alt: TensorBoard
    :target: `serving_architecture.png`_
    :align: center
    :figclass: align-center

See model_serving_ for more information.

.. _experiments: ./experiment.html
.. _model_serving: ./model_serving.html
.. _hops-py: http://hops-py.logicalclocks.com
.. _experiment: http://hops-py.logicalclocks.com/hops.html#module-hops.experiment
.. _hops-examples: https://github.com/logicalclocks/hops-examples/tree/master/tensorflow/notebooks
.. _spark-magic: https://github.com/logicalclocks/hops-examples/blob/master/tensorflow/notebooks/Plotting/Data_Visualizations.ipynb
.. _facets: https://github.com/logicalclocks/hops-examples/blob/master/tensorflow/notebooks/Plotting/facets-overview.ipynb
.. _papers: https://arxiv.org/abs/1707.02968
.. _jupyter: ../user_guide/hopsworks/jupyter.html


Pipeline Orchestration
-------

HopsML pipelines are typically run as Airflow pipelines. A workflow is defined as a directed acyclic graph (DAG) of tasks to be executed, and Airflow adds orchestration rules, failure handling, and notifications. 

.. _hopsml-airflow.png: ../_images/hopsml-airflow.png
.. figure:: ../imgs/hopsml-airflow.png
    :alt: HopsML Pipeline orchestrated by Airflow
    :target: `hopsml-airflow.png`_
    :align: center
    :figclass: align-center

