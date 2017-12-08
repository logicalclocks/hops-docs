Hops Python library
=======================

The Hops library provides a set of modules that makes it simple to run TensorFlow code on Jupyter in Hops.


hdfs
-----------------------
.. highlight:: python

The *hdfs* module provides several for interacting with HopsFS where your data is stored. The first one is ``hdfs.project_path()`` The path resolves to the root path for your project, which is the view that you see when you click ``Data Sets`` in HopsWorks. To point where your actual data resides in the project you to append the full path from there to your Dataset. For example if you create a mnist folder in your ``Resources`` dataset, which is created automatically for each project, the path to the mnist data would be ``hdfs.project_path() + 'Resources/mnist'``

::

    from hops import hdfs
    hdfs.project_path()
    
    
To write log entries, the ``hdfs.log(string)`` method is used. It will write the string to a specific logfile for each experiment. The logfiles are stored in the same directory as your TensorBoard events, namely in /Logs/TensorFlow/{appId}/{runId}. Keep in mind that this is a separate log from the one shown in the Spark UI in Jupyter, which is simply the stdout and stderr of the running job.

::

    from hops import hdfs
    hdfs.log('Some string')    
    
    
tflauncher
-----------------------------
The ``tflauncher`` module is used for running TensorFlow experiments. After each job is finished, the log directory for that job execution is put in HopsFS.
It can either be run with or without the ``args_dict argument`` that defines the hyperparameter values.
::

    from hops import tflauncher
    root_tensorboard_logdir = tflauncher.launch(spark, wrapper)
    
    
    
    
tensorboard
------------------------------
When the *launch* method in the *tflauncher* module is invoked, a TensorBoard server will be started and available for each job. The *tensorboard* module provides a *logdir* method to get the log directory for summaries and checkpoints that is to be written to the TensorBoard. After the each job is finished, the contents of the log directory will be placed in your HopsWorks project, specifically in the Logs dataset. The directory name will correspond to the values of the hyperparameters for that particular job. The log directory could therefore be used also write the final model or any other files that should be available after execution is finished, alternatively you can of course also write the model to a directory in your HopsWorks project.

The *launch* function in *tflauncher*, will return the directory in HopsFS, where each log directory is stored after execution is finished. The *visualize* method in *tensorboard* takes this path as an argument, and will start a new TensorBoard containing all the log directories of the execution, which will provide an easy way to identify the best model. Using this method, it is also possible to visualize old runs by simply supplying the path to this log directory from old runs.

::

    # Somewhere in your TensorFlow code 
    from hops import tensorboard
    # Get the log directory
    logdir = tensorboard.logdir()

    
    # Launching your training and visualizing everything in the same TensorBoard
    from hops import tensorboard
    import hops import tflauncher
    hdfs_path = tflauncher.launch(spark, training_fun, args_dict)
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

