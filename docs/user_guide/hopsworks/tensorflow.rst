TensorFlow on Hops
==================

Hops provides support for running TensorFlow on a Hops cluster. The development environment for doing so is in Jupyter notebooks.
The data should be stored as a dataset in your HopsWorks project. It is stored in HopsFS, which is essentially a fork of HDFS, and as such is also supported by
TensorFlow.


Hyperparameter search with tflauncher
-------------------------------------
We currently support three different modes of running TensorFlow, that are meant for different purposes and use-cases.
To execute the Python code in YARN containers on the Hops cluster, we make use of Spark to distribute and execute the code, so effectively we run TensorFlow on Spark.
When starting Jupyter in HopsWorks, certain configuration properties need to be filled in and understood, therefore it is recommended to look at each guide to
understand the implications of these values.

.. toctree::
:maxdepth: 1

       ../tensorflow/tensorflow_jupyter.rst


`hops` python library was developed to make it simple to run TensorFlow on Hops and scale-out training.
It contains several submodules that can be used for interacting with services on Hops and more.

.. toctree::
:maxdepth: 1

       ../tensorflow/hops.rst


Hyperparameter search with tflauncher
-------------------------------------

The `tflauncher` was developed to run parallel hyperparameter search/optimization.
The use-case of this library is to define a TensorFlow function containing the code to run, with hyperparameters as the arguments for this function.
This would effectively create multiple jobs, where each job is the same TensorFlow code running with a distinct set of hyperparameter values.
By increasing the number of Spark executors for Jupyter, it would be possible to run multiple jobs in parallel and increase throughput.
Furthermore, the training for all the jobs can be visualized in the same TensorBoard in HopsWorks. Each TensorBoard logdir is then placed in your HopsWorks project,
versioned with the particular hyperparameters set for that job.

.. toctree::
:maxdepth: 1

       ../tensorflow/tflauncher.rst

Distributed TensorFlow with TensorFlowOnSpark
---------------------------------------------

Originally developed by Yahoo, TensorFlowOnSpark is essentially a wrapper for Distributed TensorFlow (https://www.tensorflow.org/deploy/distributed) and in that sense, TensorFlowOnSpark supports all features which Distributed TensorFlow provides, such as asynchronous or synchronous training.
Hops have since done some improvements since we have the ability to schedule GPUs, it is for example possible to define how many GPUs each worker should be allocated.

The `TFCluster` API remains the same, so any existing examples will run on TensorFlowOnSpark on Hops. The framework is then fully compatible with the python libraries provided by Hops such as ``tensorboard`` and ``hdfs``.

.. toctree::
:maxdepth: 1

       ../tensorflow/tensorflow_on_spark.rst

Near-linear scalability with Horovod
------------------------------------

Horovod is a distributed training framework for TensorFlow. The goal of Horovod is to make distributed Deep Learning fast and easy to use.
Compared to TensorFlowOnSpark (Distributed TensorFlow), the programming model is significantly simpler, and it requires only a couple of changes to your existing code to convert a non-distributed training code to distributed.

Running Horovod is done using the `allreduce` module and can be combined with our other modules such `tensorboard` to show TensorBoard for the training.
Currently we support running Horovod on 1 host, which means that depending on how many GPUs are available on the machine will limit the scalability.
We will soon support multiple hosts.

.. toctree::
:maxdepth: 1

       ../tensorflow/horovod.rst

