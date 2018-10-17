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

Data Collection
---------------

The datasets that you are working with will reside in your project in HopsFS. Datasets can be uploaded to your Hopsworks project or be shared from an other project. HopsFS is the filesystem of Hops, it is essentially a fork of Apache HDFS and is compliant with any API that can read data from an HDFS path, such as TensorFlow. In your TensorFlow code you can simply replace local file paths to the corresponding path in HDFS. More information is available `here <https://www.tensorflow.org/deploy/hadoop>`_..

Data Transformation & Verification
----------------------------------


Feature Extraction
------------------


Experimentation
---------------------------

Jupyter notebooks (documentation for Jupyter on Hopsworks: experimentation)

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
