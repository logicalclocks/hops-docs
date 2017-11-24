Hops Python library
=======================

The Hops library provides a set of modules that makes it simple to run TensorFlow code on Jupyter in Hops.


hdfs
-----------------------
.. highlight:: python

The *hdfs* module provides a single method to get the path in HopsFS where your data is stored, namely by calling ``hdfs.project_path()``. The path resolves to the root path for your project, which is the view that you see when you click ``Data Sets`` in HopsWorks. To point where your actual data resides in the project you to append the full path from there to your Dataset. For example if you create a mnist folder in your Resources Dataset, which is created automatically for each project, the path to the mnist data would be ``hdfs.project_path() + 'Resources/mnist'``

::

    from hops import hdfs
    hdfs.project_path()

tensorboard
------------------------------
The *tensorboard* module allow us to get the log directory for summaries and checkpoints that is to be written to the TensorBoard.
The ``tflaunch.launch`` function, which you can then navigate to using HopsWorks to inspect the files.

The directory could in practice be used to store other data that should be accessible after each hyperparameter configuration is finished.
::

    from hops import tensorboard

    # Get the log directory
    logdir = tensorboard.logdir()

    # Visualize TensorBoard from HopsFS
    tensorboard.visualize(spark, hdfs_path)


devices
--------------------------
The *devices* module provides a single method ``get_num_gpus``, that depending on how many GPUs that were allocated per Spark Executor.
This method is suitable for scaling out dynamically depending on how many GPUs have been configured, for example when using a multi-gpu tower.
See the ``multi-gpu-cnn.ipynb`` example in the TensorFlow tour.

::

    from hops import devices
    num_gpus = devices.get_num_gpus()


tflauncher
-----------------------------
The ``tflauncher`` module is used for running TensorFlow experiments. After each job is finished, the log directory for that job execution is put in HopsFS.
It can either be run with or without the ``args_dict argument`` that defines the hyperparameter values.
::

    from hops import tflauncher
    root_tensorboard_logdir = tflauncher.launch(spark, wrapper)

allreduce
----------------------------
The *allreduce* module is used for launching Horovod jobs.

::

    from hops import allreduce
    allreduce.launch(spark, '/Projects/ + hdfs.project_name() + '/Jupyter/horovod.ipynb')

util
-----------------------
The *util* module is used to expose certain helper methods.

::

    from hops import util

    # Get the number of parameter servers and executors configured for Jupyter
    num_param_servers = util.num_param_servers(spark)
    num_executors = util.num_executors(spark)

    # Create a grid of hyperparameter arguments
    args_dict = {'learning_rate': [0.001, 0.0005, 0.0001], 'dropout': [0.45, 0.7]}
    args_dict_grid = util.grid_params(args_dict)

