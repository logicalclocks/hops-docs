Hops Python library
=======================

**Hops library** provides a set of modules that make it simple to run TensorFlow code with Jupyter on Hops.


hdfs
-----------------------
.. highlight:: python

The ``hdfs`` module provides several ways of interacting with the Hops filesystem, where the Hopsworks project's data is stored. 

**Pointing to a Dataset in Hopsworks**


In order to point to a dataset in Hopsworks the ``hdfs.project_path()`` function should be called. The function will return the HDFS path of your project, which is the view shown when clicking at ``Data Sets`` in Hopsworks. To point where your actual data resides in the project, you need to append the full path from there to your Dataset. 

::   

    from hops import hdfs
    my_project_path = hdfs.project_path()
    
It is also possible to pass an argument corresponding to a different project for which you want to resolve the path to.    

::   

    from hops import hdfs
    other_project_path = hdfs.project_path('deep-learning-101')    
   
    
A simple use-case might be writing to a file in your project. Depending on whether you are using Python or PySpark kernel, you can follow one of two these different approaches in Jupyter.

**Logging in the Python kernel**

::   

    from hops import hdfs
    fs_handle = hdfs.get_fs()
    
    # Write to file in Hopsworks Resources dataset
    logfile = hdfs.project_path() + 'Resources/file.txt'
    fd = fs_handle.open_file(logfile, flags='w')
    fd.write('Hello Hopsworks')
    fd.close()    
    
**Logging in the PySpark kernel**
    
When using the PySpark kernel you have to specify a wrapper function that you want to run on the executors. This wrapper function must be executed using the ``experiment`` module. To write log entries, the ``hdfs.log(string)`` method is used. It will write the string to a specific logfile for each experiment. The logfiles are stored in ``/Logs/TensorFlow/{appId}/{runId}/{hyperparameter}``. Keep in mind that this is a separate log from the one shown in the Spark UI in Hopsworks, which is simply the *stdout* and *stderr* of the running job.

::
    
    def wrapper():
        from hops import hdfs
        hdfs.log('Hello Hopsworks')
        
    from hops import experiment
    experiment.launch(spark, wrapper)
    
**Accessing datasets in Python or PySpark kernels**

If you are using a framework such as TensorFlow you can read data directly from your project, since TensorFlow supports the HDFS filesystem and therefore HopsFS.

This section is directed towards users that may want to use other frameworks such as *PyTorch* or *Theano* that do not support directly reading from HDFS. In this case the solution is to download the datasets to the executor running your code and then feed it in your program.
In order to easily copy datasets to and from your executor's working space and your Hopsworks project, the ``hdfs.copy_from_project`` and ``hdfs.copy_to_project`` functions should be used.

::

    # -- How to copy a dataset from your Hopsworks project --

    # When using the Python Kernel
    # This code will copy the file mydata.json in the Resources dataset and place it in the root of your PDIR directory
    from hops import hdfs
    hdfs.copy_from_project('Resources/mydata.json', '')

    # When using the PySpark Kernel
    # This code will copy the file mydata.json in the Resources dataset and place it in the current working directory
    # Important! This is not persistently stored and will be removed when the executor is killed (job is complete or timeout)
    def wrapper():
        from hops import hdfs
        hdfs.copy_from_project('Resources/mydata.json', '')


    # Launch using experiment
    from hops import experiment
    experiment.launch(spark, wrapper)


    # -- How to upload a dataset to your Hopsworks project --

    # When using the Python Kernel
    # This code will copy the file mydata.json located in your PDIR directory and place it in the Resources dataset of your Hopsworks project
    from hops import hdfs
    hdfs.copy_to_project('mydata.json', 'Resources/')

    # When using the PySpark Kernel
    # This code will copy the file mydata.json in your working directory and place it in the Resources dataset
    def wrapper():
        from hops import hdfs
        hdfs.copy_to_project('mydata.json', 'Resources/')


    # Launch using experiment
    from hops import experiment
    experiment.launch(spark, wrapper)


experiment
----------
The ``experiment`` module is used for running one or more Parallel TensorFlow experiments, which corresponds to selecting the TensorFlow mode in Jupyter. It can either be ran with or without the ``args_dict`` argument that define hyperparameter values.

::

    def single_experiments_wrapper():
        # Wrapper function for a single experiment with hardcoded parameters

    # A standalone job
    from hops import experiment
    root_tensorboard_logdir = experiment.launch(spark, single_experiments_wrapper)
    
    ...............................................................................................
    
    def multiple_experiments_wrapper(lr, dropout):
        # Wrapper function for arbitrarily many experiments
        
    # Running two experiments
    args_dict = {'lr': [0.1, 0.3], 'dropout': [0.4, 0.7]}
    
    # This code will run two jobs
    # job1: lr=0.1 and dropout=0.4
    # job2: lr=0.3 and dropout=0.7
    
    from hops import experiment
    root_tensorboard_logdir = experiment.launch(spark, multiple_experiments_wrapper, args_dict)
    
    ...............................................................................................
    
    def grid_experiments_wrapper(lr, dropout):
        # Wrapper function for arbitrarily many experiments
        
    # Running a grid of hyperparameter experiments
    args_dict = {'lr': [0.1, 0.3], 'dropout': [0.4, 0.7]}

    # This code will run four jobs
    # job1: lr=0.1 and dropout=0.4
    # job2: lr=0.1 and dropout=0.7
    # job3: lr=0.3 and dropout=0.4
    # job4: lr=0.3 and dropout=0.7
    
    from hops import experiment

    root_tensorboard_logdir = experiment.grid_search(spark, grid_experiments_wrapper, args_dict, direction='max')
    
    ...............................................................................................
    
    def evolutionary_experiments_wrapper(lr, dropout):
        # Wrapper function for arbitrarily many experiments
        metric = mycode.evaluate(lr, dropout)
        return metric
        
    # Running a grid of hyperparameter experiments
    search_dict = {'lr': [0.1, 0.3], 'dropout': [0.4, 0.7]}
    
    from hops import experiment
    root_tensorboard_logdir = experiment.evolutionary_search(spark, evolutionary_experiments_wrapper, search_dict, direction='max')
    
    
tensorboard
------------------------------
Hops supports TensorBoard for all TensorFlow modes (Parallel experiments, TensorFlowOnSpark and Horovod). 
When the ``experiment.launch`` function is invoked, a TensorBoard server will be started and available for each job. The *tensorboard* module provides a *logdir* method to get the log directory for summaries and checkpoints that are to be written to the TensorBoard. After each job is finished, the contents of the log directory will be placed in your Hopsworks project, under ``/Logs/TensorFlow/{appId}/{runId}/{hyperparameter}``. The directory name will correspond to the values of the hyperparameters for that particular job. The log directory could therefore be used to also write the final model or any other files that should be made available after execution is finished. Alternatively you can of course also write the model to any directory in your Hopsworks project.

The *launch* function in *experiment* will return the directory in HopsFS, where each log directory is stored after execution is finished. The *visualize* method in *tensorboard* takes this path as an argument, and will start a new TensorBoard containing all the log directories of the execution, which will provide an easy way to identify the best model. Using this method, it is also possible to visualize old runs by simply supplying the path to this log directory from old runs.

::

    # Import tensorboard
    from hops import tensorboard

    # Get the log directory
    logdir = tensorboard.logdir()

    # Get the interactive debugger endpoint of the TensorBoard
    debugger_endpoint = tensorboard.interactive_debugger()

    # Get the non-interactive debugger endpoint of the TensorBoard
    debugger_endpoint = tensorboard.non_interactive_debugger()
    
    # Launching your training and visualizing everything in the same TensorBoard
    from hops import tensorboard
    import hops import experiment
    hdfs_path = experiment.launch(spark, training_fun, args_dict)
    # Visualize TensorBoard from HopsFS
    tensorboard.visualize(spark, hdfs_path)



devices
--------------------------
The *devices* module provides a single method ``get_num_gpus``, which returns the number of GPUs that were discovered in the environment. This method is suitable for scaling out dynamically depending on how many GPUs have been configured, for example when using a multi-gpu tower.

::

    from hops import devices
    num_gpus = devices.get_num_gpus()


allreduce
----------------------------
The *allreduce* module is used for launching Horovod jobs.

::

    from hops import allreduce
    allreduce.launch(spark, '/Projects/' + hdfs.project_name() + '/Jupyter/horovod.ipynb')

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

