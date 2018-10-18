HopsML
======

The Pipeline
------------

.. _pipeline.png: ../../_images/pipeline.png
.. figure:: ../../imgs/pipeline.png
    :alt: Increasing throughput
    :target: `pipeline.png`_
    :align: center
    :figclass: align-center
    
    
Hops Python Library
-------------------

The Hops Python Library simply named ´hops´ is used for running Python applications and consequently a library which is used throughout the entire pipeline. It simplifies interacting with services such as Kafka, Model Serving and TensorBoard. The experiment module provides a rich API for running versioned Machine Learning experiments, whether it be a simple single-process Python application or RingAllReduce over many machines.

Documentation: hops-py_ 

Code examples: hops-examples_ 
    
PySpark
-------

The HopsML pipeline makes use of `Apache Spark <https://spark.apache.org/>`_ to leverage distributed processing capabilities. Spark, as defined by its creators is a fast and general engine for large-scale data processing. There are three main use-cases for Spark in the HopsML pipeline.

1. Data validation, transformations and feature extraction

2. Dynamic resource allocation of the resources (CPU, Memory and GPUs) in the cluster.

3. Orchestration and execution of Machine Learning code.

Data Collection
---------------

The datasets that you are working with will reside in your project in HopsFS. Datasets can be uploaded to your Hopsworks project or be shared from another project. HopsFS is the filesystem of Hops, it is essentially a fork of Apache HDFS and is compliant with any API that can read data from an HDFS path, such as TensorFlow. In your TensorFlow code you can simply replace local file paths to the corresponding path in HDFS. More information is available `here <https://www.tensorflow.org/deploy/hadoop>`_.
Data can also be ingested using Kafka or Spark Streaming.

Data Transformation & Verification
----------------------------------

Spark Dataframes can be used to transform and validate large datasets in a distributed manner. For example schemas can be used to validate the datasets. Useful insights can be calculated such as class imbalance, null values for fields and value ranges. Datasets can be transformed by dropping or filtering fields.

Validation and visualization is easily done in Jupyter. See visualizations_ here.

Feature Extraction
------------------

This part of the pipeline is still in development. The plan is to release a Feature Store.


Experimentation, Training and Testing
-------------------------------------

This section will give an overview of running Machine Learning experiments on Hops. See experiments_ for more information.

In PySpark, Hops runs a different experiment on each executor – not all of the experiments will finish at the same time. Some experiments may finish early, some later. And GPUs cannot currently be shared (multiplexed) by concurrent applications. Population-based approaches for AutoML, typically proceed in stages or iterations, meaning all experiments wait for other experiments to finish, resulting in idle GPU time. That is, GPUs lie idle waiting for other experiments to finish.

As such, we have the problem of how to free up the GPUs as soon as its experiment is finished. Hops leverages dynamic executors in PySpark to free up the GPU(s) attached to an executor immediately if it sits idle waiting for other experiments to finish, ensuring that (expensive) GPUs are held no longer than needed.

Each Spark executor runs a local TensorFlow process. Hops also supports cluster-wide Conda for managing python library dependencies. Hops supports the creation of projects, and each project has its own conda environment, replicated at all hosts in the cluster. When you launch a PySpark job, it uses the local conda environment for that project. This way, users can install whatever libraries they like using conda and pip, and then use them directly inside Spark Executors. It makes programming PySpark one step closer to the single-host experience of programming Python.

In HopsML we separate Machine Learning experiments into three differents categories.

**Experiment**

A single python program that runs with a set of predefined hyperparameters. 

**Parallel Experiments**

A set of hyperparameters to try given some hyperparameter optimization algorithm. Supported algorithms currently include grid search and differential evolution. In the future more algorithms will be added.

**Distributed Training**

Training involving multiple gpus and/or multiple hosts. Distributed Training is only supported for TensorFlow and Keras using CollectiveAllReduceStrategy, ParameterServerStrategy and MirroredStrategy.


Serving
-------

In the pipeline we support a scalable architecture for serving of TensorFlow and Keras models. We use the TensorFlow Serving running on K8s to scale up the number of serving instances dynamically and handle load balancing.

See model_serving_ for more information.

.. _experiments: ../hopsml/experiment.html
.. _model_serving: ../hopsml/model_serving.html
.. _hops-py: http://hops-py.logicalclocks.com
.. _hops-examples: https://github.com/logicalclocks/hops-examples/tree/master/tensorflow/notebooks
.. _visualizations: https://github.com/logicalclocks/hops-examples/blob/master/tensorflow/notebooks/Plotting/Data_Visualizations.ipynb
