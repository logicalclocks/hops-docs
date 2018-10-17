HopsML
==================

The Pipeline
------------

.. figure:: ../../imgs/pipeline.png
    :alt: Increasing throughput
    :scale: 100
    :align: center
    :figclass: align-center
    
PySpark
-------

In the HopsML pipeline we make use of `Apache Spark <https://spark.apache.org/>`_ to leverage distributed processing capabilities. Spark, as defined by its creators is a fast and general engine for large-scale data processing. In the HopsML pipeline we have two main use cases for Spark. The first use-case being data validation, transformations and feature extractions on potentially huge datasets.

In PySpark, Hops runs a different experiment on each executor – not all of the experiments will finish at the same time. Some experiments may finish early, some later. And GPUs cannot currently be shared (multiplexed) by concurrent applications. Population-based approaches for AutoML, typically proceed in stages or iterations, meaning all experiments wait for other experiments to finish, resulting in idle GPU time. That is, GPUs lie idle waiting for other experiments to finish.

As such, we have the problem of how to free up the GPUs as soon as its experiment is finished. Hops leverages dynamic executors in PySpark/YARN to free up the GPU(s) attached to an executor immediately if it sits idle waiting for other experiments to finish, ensuring that (expensive) GPUs are held no longer than needed.

Each Spark executor runs a local TensorFlow process. Hops also supports cluster-wide Conda for managing python library dependencies. Hops supports the creation of projects, and each project has its own conda environment, replicated at all hosts in the cluster. When you launch a PySpark job, it uses the local conda environment for that project. This way, users can install whatever libraries they like using conda and pip, and then use them directly inside Spark Executors. It makes programming PySpark one step closer to the single-host experience of programming Python. Hops also supports Jupyter and the SparkMagic kernel for running PySpark jobs.

Data Collection
---------------

The datasets that you are working with will reside in your project in HopsFS. Datasets can be uploaded to your Hopsworks project or be shared from an other project. HopsFS is the filesystem of Hops, it is essentially a fork of Apache HDFS and is compliant with any API that can read data from an HDFS path, such as TensorFlow. In your TensorFlow code you can simply replace local file paths to the corresponding path in HDFS. More information is available `here <https://www.tensorflow.org/deploy/hadoop>`_..

Data Transformation & Verification
----------------------------------


Feature Extraction
------------------


Experimentation
---------------------------

In HopsML we separate Machine Learning experiments into three differents categories.

**Experiment**

A single python program that runs with a set of predefined hyperparameters. 

**Parallel Experiments**

A set of hyperparameters to try given some hyperparameter optimization algorithm.

**Distributed Training**

Training involving multiple gpus and/or multiple hosts.


.. toctree::
   :maxdepth: 1

   ../tensorflow/experiment.rst
   ../tensorflow/mml.rst
   ../tensorflow/model_serving.rst
   ../tensorflow/inference.rst
