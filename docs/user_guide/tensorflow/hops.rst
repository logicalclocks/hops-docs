Hops Python library
=======================

The Hops library provides a set of modules that makes it simple to run TensorFlow code on Jupyter in Hops.


hdfs
-----------------------
.. highlight:: python

The ``hdfs`` module provides several for interacting with HopsFS where your data is stored. The first one is ``hdfs.project_path()`` The path resolves to the root path for your project, which is the view that you see when you click ``Data Sets`` in HopsWorks. To point where your actual data resides in the project you to append the full path from there to your Dataset. For example if you create a mnist folder in your ``Resources`` dataset, which is created automatically for each project, the path to the mnist data would be ``hdfs.project_path() + 'Resources/mnist'``. It is also possible to write to files in your HopsWorks project using the ``hdfs`` module. However this code must be wrapped in a function and executed using the ``tflauncher`` module.

::

    def wrapper():
        from hops import hdfs
        fs_handle = hdfs.get_fs()
    
        # Write to file in HopsWorks Resources dataset
        logfile = hdfs.project_path() + "Resources/file.txt"
        fd = fs_handle.open_file(logfile, flags='w')
        fd.write('Hello HopsWorks')
        fd.close()

    from hops import tflauncher
    tflauncher.launch(spark, wrapper)       
     
    
    
To write log entries, the ``hdfs.log(string)`` method is used. It will write the string to a specific logfile for each experiment. The logfiles are stored in ``/Logs/TensorFlow/{appId}/{runId}/{hyperparameter}``. Keep in mind that this is a separate log from the one shown in the Spark UI in HopsWorks, which is simply the stdout and stderr of the running job.

::

    def wrapper():
        from hops import hdfs
        hdfs.log('Hello HopsWorks')
        
    from hops import tflauncher
    tflauncher.launch(spark, wrapper)    

If you are using a framework such as TensorFlow you can read data directly from HopsFS, since it is an HDFS filesystem which TensorFlow supports.
Some users may want to use other frameworks such as PyTorch, in this case you will have to download the data locally and then feed it in your program.
In order to easily copy datasets from your working space and your HopsWorks project the ``hdfs.copy_from_project`` and ``hdfs.copy_to_project`` should be used.

::
    # When using the Python Kernel
    # This code will copy the file mydata.json in the Resources dataset and place it in the root of your PDIR directory
    from hops import hdfs
    hdfs.copy_from_project("Resources/mydata.json", "")

    # When using the PySpark Kernel
    # This code will copy the file mydata.json in the Resources dataset and place it in the current working directory
    # Important! This is not persistently stored and will be removed when the executor is killed (job is complete or timeout)
    def wrapper():
        from hops import hdfs
        hdfs.copy_from_project("Resources/mydata.json", "")


    # Launch using tflauncher
    from hops import tflauncher
    tflauncher.launch(spark, wrapper)


tflauncher
----------
The ``tflauncher`` module is used for running one or more Parallel TensorFlow experiments. Which corresponds to selecting the TensorFlow mode in Jupyter. It can either be run with or without the ``args_dict`` argument that define hyperparameter values.
::

    def single_experiments_wrapper():
        # Wrapper function for a single experiment with hardcoded parameters

    # A standalone job
    from hops import tflauncher
    root_tensorboard_logdir = tflauncher.launch(spark, single_experiments_wrapper)
    
    ...............................................................................................
    
    def multiple_experiments_wrapper(lr, dropout):
        # Wrapper function for arbitrarily many experiments
        
    # Running two experiments
    from hops import tflauncher
    args_dict = {'lr': [0.1, 0.3], 'dropout': [0.4, 0.7]}
    
    # This code will run two jobs
    # job1: lr=0.1 and dropout=0.4
    # job2: lr=0.3 and dropout=0.7
    root_tensorboard_logdir = tflauncher.launch(spark, multiple_experiments_wrapper, args_dict)
    
    ...............................................................................................
    
    def grid_experiments_wrapper(lr, dropout):
        # Wrapper function for arbitrarily many experiments
        
    # Running a grid of hyperparameter experiments
    from hops import tflauncher
    args_dict = {'lr': [0.1, 0.3], 'dropout': [0.4, 0.7]}
    
    from hops import util
    # This code creates a grid, so all possible hyperparameter combinations of ``lr`` and ``dropout``
    args_dict_grid = util.grid_params(args_dict)
    
    # This code will run four jobs
    # job1: lr=0.1 and dropout=0.4
    # job2: lr=0.1 and dropout=0.7
    # job3: lr=0.3 and dropout=0.4
    # job4: lr=0.3 and dropout=0.7
    root_tensorboard_logdir = tflauncher.launch(spark, grid_experiments_wrapper, args_dict_grid)  
    
    
    
tensorboard
------------------------------
TensorBoard is supported for all TensorFlow modes (Parallel experiments, TensorFlowOnSpark and Horovod). 
When the ``tflauncher.launch`` function is invoked, a TensorBoard server will be started and available for each job. The *tensorboard* module provides a *logdir* method to get the log directory for summaries and checkpoints that is to be written to the TensorBoard. After the each job is finished, the contents of the log directory will be placed in your HopsWorks project, in the path ``/Logs/TensorFlow/{appId}/{runId}/{hyperparameter}``. The directory name will correspond to the values of the hyperparameters for that particular job. The log directory could therefore be used also write the final model or any other files that should be available after execution is finished, alternatively you can of course also write the model to a directory in your HopsWorks project.

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

