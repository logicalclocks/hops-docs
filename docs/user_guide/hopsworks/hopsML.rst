HopsML
==================

**The Pipeline on Hops**

.. figure:: ../../imgs/pipeline.png
    :alt: Increasing throughput
    :scale: 100
    :align: center
    :figclass: align-center
    
PySpark
-------

In the HopsML pipeline we make use of `Apache Spark <https://spark.apache.org/>`_ to leverage distributed processing capabilities. Spark, as defined by its creators is a fast and general engine for large-scale data processing. It is a general distributed processing engine that can fit many use-cases. In the HopsML pipeline we have two main use cases for Spark. The first use-case being data validation, transformations and feature extractions on potentially huge datasets. The second use-case is to orchestrate allocation of cluster resources and execution of Machine Learning applications such as TensorFlow, Keras and PyTorch.

Data Collection
---------------

The datasets that you are working with will reside in your project in HopsFS. Datasets can be uploaded to your Hopsworks project or be shared from an other project. HopsFS is the filesystem of Hops, it is essentially a fork of Apache HDFS and is compliant with any API that can read data from an HDFS path, such as TensorFlow. In your TensorFlow code you can simply replace local file paths to the corresponding path in HDFS. More information is available `here <https://www.tensorflow.org/deploy/hadoop>`_..

Kafka

Data Transformation & Verification
----------------------------------


Feature Extraction
------------------


Experimentation
---------------------------

In HopsML we separate machine learning experiments into three differents categories.

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


Mode 1. Parallel Experiments
----------------------------

The use case of this mode is to run multiple parallel experiments. To find the best model for your prediction task is not a trivial process. You need to decide on a model and some hyperparameters and then run your training/evaluation until you are satisfied.

We provide different mechanisms to parallelize the search for your best model such as evolutionary hyperparameter optimization or grid search. Typically you will have a set of **predefined hyperparameters** and a list of values per hyperparameter that should be used to run training with. Based on this list of hyperparameter values, a grid can be constructed (cartesian product). Each of these possible hyperparameter combinations in the grid corresponds to a TensorFlow job, or an *experiment*. Running each of these hyperparameters configuration sequentially would be slow, therefore we provide a simple API to **parallelize** execution on one or more *executors*.

While training you will be able to see how training progresses using TensorBoard. After running all the experiments, it is possible to visualize all experiments in the **same** TensorBoard to more easily identify which hyperparameter combinations yield the best results.

Each TensorBoard log directory is then placed in your Hopsworks project, versioned with the hyperparameter values for that particular hyperparameter combination, so that you can visualize experiments from previous jobs too.

