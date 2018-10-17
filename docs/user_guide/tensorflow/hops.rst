Hops Python library
=======================

<<<<<<< a2c5d395396d6cfbea2fddd54af1a05b24f9e46a
**Hops library** provides a set of modules that make it simple to run TensorFlow code with Jupyter on Hops. The API documentation is available here: API-docs_.
=======
**Hops library** provides a set of modules that make it simple to run Python applications for large-scale processing on Hops.
>>>>>>> Update hops.rst

`hops-util-py` is a helper library for Hops that facilitates development by hiding the complexity of running applications, discovering services and interacting with HopsFS.

For documentation and examples see: `<http://hops-py.logicalclocks.com//>`

It provides an Experiment API to run Python programs such as TensorFlow, Keras and PyTorch on a Hops Hadoop cluster. A TensorBoard will be started when an Experiment begins and the contents of the logdir saved in your Project. An Experiment could be a single Python program, which we refer to as an *Experiment*.

<<<<<<< cf11bea59bd66ec796caccdce04ebb7849c0b2d8
The ``hdfs`` module provides several ways of interacting with the Hops filesystem, where the Hopsworks project's data is stored.

**Getting Project Information**

::

    from hops import hdfs
    project_user = hdfs.project_user() # returns: ProjectName__ProjectUserId
    project_name = hdfs.project_name() # returns: ProjectName
    project_path = hdfs.project_path() # returns: hdfs://ip:port/Projects/ProjectName/


A common use-case for using the hdfs module to get project information is when you need to provide a path to your project-datasets for reading the dataset in your program, for example using a framework like Spark or Tensorflow. When providing a path to a dataset in your project, you'll typically write ``hdfs.project_path() + DATASET_NAME/...``. What's happening here is that ``hdfs.project_path()`` returns the HDFS path to your project, this is the path you preview when you visit the ``Data Sets`` view in Hopsworks. To get the full HDFS path to the dataset, the dataset name is appended to the project path.

By default, ``hdfs.project_path()`` returns the path to the project that you are using while running the code. However, if you want to get the HDFS path to another project, you can pass an argument to the function with the project name:

::

    from hops import hdfs
    other_project_path = hdfs.project_path('deep-learning-101') #returns hdfs://ip:port/Projects/deep-learning-101/


The practice of passing an argument to  ``hdfs.project_path()`` is commonly used when another project has shared a dataset with your project and you want to read that dataset in your program.

**Read/Write From/To HDFS**

To read and write from/to HDFS *without* using a framework like Spark or Tensorflow, you can use the hops utility functions ``load(hdfs_path)`` and ``dump(data, hdfs_path)`` in the hops utility library.
::

    from hops import hdfs
    logs_README = hdfs.load("Logs/README.md") #reads a file in HDFS as raw bytes
    print("logs README: {}".format(logs_README.decode("utf-8"))) # decodes the bytes into a string and prints it
    hdfs.dump("test", "Logs/README_dump_test.md") # writes the string 'test' to hdfs://ip:port/Projects/ProjectName/Logs/README_dump_test_md

    # alternative method for writing/reading to HDFS is to get the filesystem handle from the hops library and use it directly:

    fs_handle = hdfs.get_fs()
    # Write to file in Hopsworks Resources dataset
    logfile = hdfs.project_path() + 'Resources/file.txt'
    fd = fs_handle.open_file(logfile, flags='w')
    fd.write('Hello Hopsworks')
    fd.close()

Note that, in the code snippet above, when we provide the hdfs-paths to ``hdfs.load()`` and ``hdfs.dump()`` we only provide the relative paths from the project root directory, not the full HDFS paths. When using the `hops hdfs` module, you can choose either to supply the full path or the relative path. If you provide only the relative path, the library will try to expand the path to its full path before executing the operation. This is just to make the library more user-friendly so that you don't always have to write the full HDFS path. Remember though, when you provide HDFS paths to frameworks like Spark or Tensorflow, you always need to provide the full path, e.g: ``hdfs.project_path() + relative_path``.

**Logging using Hops Experiments**

When using the PySpark kernel and Hops experiments you have to specify a wrapper function that you want to run on the executors. This wrapper function must be executed using the ``experiment`` module. To write log entries, the ``hdfs.log(string)`` method is used. It will write the string to a specific logfile for each experiment. The logfiles are stored in ``/Logs/TensorFlow/{appId}/{runId}/{hyperparameter}``. Keep in mind that this is a separate log from the one shown in the Spark UI in Hopsworks, which is simply the *stdout* and *stderr* of the running job.

::

    def wrapper():
        from hops import hdfs
        hdfs.log('Hello Hopsworks')

    from hops import experiment
<<<<<<< e2657dfd4d8a575b9cb44893fd2c604670858d77
    experiment.launch(spark, wrapper)

**Copying Datasets From/To HDFS**
=======
    experiment.launch(wrapper)
    
**Accessing datasets in Python or PySpark kernels**
>>>>>>> Update hops.rst

If you are using a framework such as TensorFlow you can read data directly from your project, since TensorFlow supports the HDFS filesystem and therefore HopsFS.

This section is directed towards users that may want to use other frameworks than Tensorflow/Spark, such as *PyTorch* or *Theano*, that do not support directly reading from HDFS. In this case the solution is to download the datasets to the executor running your code and then feed it in your program.
In order to easily copy datasets to and from your executor's working space and your Hopsworks project, the ``hdfs.copy_from_project`` and ``hdfs.copy_to_project`` functions should be used.

::

    # -- How to copy a dataset from your Hopsworks project --

    # When using the Python Kernel
    # This code will copy the file mydata.json in the Resources dataset and place it in the root of your PDIR directory
    # and name it local_file_name
    from hops import hdfs
    hdfs.copy_to_local('Resources/mydata.json', local_file_name)

    # When using the PySpark Kernel
    # This code will copy the file mydata.json in the Resources dataset and place it in the current working directory
    # and name it local_file_name
    # Important! This is not persistently stored and will be removed when the executor is killed (job is complete or timeout)
    def wrapper():
        from hops import hdfs
        hdfs.copy_to_local('Resources/mydata.json', local_file_name)


    # Launch using experiment
    from hops import experiment
    experiment.launch(wrapper)


    # -- How to upload a dataset to your Hopsworks project --

    # When using the Python Kernel
    # This code will copy the file mydata.json located in your PDIR directory and place it in the Resources dataset of your Hopsworks project
    from hops import hdfs
    hdfs.copy_to_hdfs('mydata.json', 'Resources/')

    # When using the PySpark Kernel
    # This code will copy the file mydata.json in your working directory and place it in the Resources dataset
    def wrapper():
        from hops import hdfs
        hdfs.copy_to_hdfs('mydata.json', 'Resources/')


    # Launch using experiment
    from hops import experiment
    experiment.launch(wrapper)


experiment
----------
The ``experiment`` module is used for running Experiment, Parallel Experiment or Distributed Training on Hops.

::

    def single_experiments_wrapper():
        # Wrapper function for a single experiment with hardcoded parameters

    # A standalone job
    from hops import experiment
<<<<<<< e2657dfd4d8a575b9cb44893fd2c604670858d77
    root_tensorboard_logdir = experiment.launch(spark, single_experiments_wrapper)

=======
    root_tensorboard_logdir = experiment.launch(single_experiments_wrapper)
    
>>>>>>> Update hops.rst
    ...............................................................................................

    def multiple_experiments_wrapper(lr, dropout):
        # Wrapper function for arbitrarily many experiments

    # Running two experiments
    args_dict = {'lr': [0.1, 0.3], 'dropout': [0.4, 0.7]}

    # This code will run two jobs
    # job1: lr=0.1 and dropout=0.4
    # job2: lr=0.3 and dropout=0.7

    from hops import experiment
<<<<<<< e2657dfd4d8a575b9cb44893fd2c604670858d77
    root_tensorboard_logdir = experiment.launch(spark, multiple_experiments_wrapper, args_dict)

=======
    root_tensorboard_logdir = experiment.launch(multiple_experiments_wrapper, args_dict)
    
>>>>>>> Update hops.rst
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

<<<<<<< e2657dfd4d8a575b9cb44893fd2c604670858d77
    root_tensorboard_logdir = experiment.grid_search(spark, grid_experiments_wrapper, args_dict, direction='max')

=======
    root_tensorboard_logdir = experiment.grid_search(grid_experiments_wrapper, args_dict, direction='max')
    
>>>>>>> Update hops.rst
    ...............................................................................................

    def evolutionary_experiments_wrapper(lr, dropout):
        # Wrapper function for arbitrarily many experiments
        metric = mycode.evaluate(lr, dropout)
        return metric
<<<<<<< e2657dfd4d8a575b9cb44893fd2c604670858d77

    # Running a grid of hyperparameter experiments
=======
        
    # Defining a space to search for lr and dropout
>>>>>>> Update hops.rst
    search_dict = {'lr': [0.1, 0.3], 'dropout': [0.4, 0.7]}

    from hops import experiment
<<<<<<< e2657dfd4d8a575b9cb44893fd2c604670858d77
    root_tensorboard_logdir = experiment.evolutionary_search(spark, evolutionary_experiments_wrapper, search_dict, direction='max')


tensorboard
------------------------------
Hops supports TensorBoard for all TensorFlow modes (Experiments, Parallel experiments, and Distributed training).
=======
    root_tensorboard_logdir = experiment.differential_evolution(evolutionary_experiments_wrapper, search_dict, direction='max')
    
    
tensorboard
------------------------------
Hops supports TensorBoard for all TensorFlow modes (Experiments, Parallel Experiments and Distributed Training). 
<<<<<<< a2c5d395396d6cfbea2fddd54af1a05b24f9e46a
>>>>>>> Update hops.rst
When the ``experiment.launch`` function is invoked, a TensorBoard server will be started and available for each job. The *tensorboard* module provides a *logdir* method to get the log directory for summaries and checkpoints that are to be written to the TensorBoard. After each job is finished, the contents of the log directory will be placed in your Hopsworks project, under ``/Logs/TensorFlow/{appId}/{runId}/{hyperparameter}``. The directory name will correspond to the values of the hyperparameters for that particular job. The log directory could therefore be used to also write the final model or any other files that should be made available after execution is finished. Alternatively you can of course also write the model to any directory in your Hopsworks project.

The *launch* function in *experiment* will return the directory in HopsFS, where each log directory is stored after execution is finished. The *visualize* method in *tensorboard* takes this path as an argument, and will start a new TensorBoard containing all the log directories of the execution, which will provide an easy way to identify the best model. Using this method, it is also possible to visualize old runs by simply supplying the path to this log directory from old runs.
=======
When the ``experiment.launch`` function is invoked, a TensorBoard server will be started and available for each job. The *tensorboard* module provides a *logdir* method to get the log directory for summaries and checkpoints that are to be written to the TensorBoard. After each job is finished, the contents of the log directory will be placed in your Hopsworks project, in the ``Experiments`` dataset. The log directory could therefore be used to also write the final model or any other files that should be made available after execution is finished. Alternatively you can of course also write the model to any directory in your Hopsworks project.
>>>>>>> Update hops.rst

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


kafka
-----------------------
The *kafka* module is used for creating Kafka consumers/producers to communicate with a Kafka cluster running in Hops using secure SSL/TLS communication.

For using kafka with the hops library you should already have created your kafka topics through Hopsworks (see instructions here: hopskafka_.)

.. _hopskafka: ../hopsworks/kafka.html
**Defining the Kafka configuration**

The module provides utility methods for setting up secure communication using Kafka producers and consumers running inside a Hopsworks cluster. You can use this utility methods in combination with any python kafka client. In the examples below we will show how you can use ``confluent-kafka-python`` and ``Spark`` clients for creating Kafka producers and consumers with minimal amount of code.

::

    from hops import kafka
    from hops import tls

    # the default configuration is designed for use with confluent-kafka-python
    config = kafka.get_kafka_default_config()

    # if you want to use another library than confluent-kafka-python or configure the default config
    # you can call the individual utility functions and set the configuration as required
    config = {
        "bootstrap.servers": kafka.get_broker_endpoints(),
        "security.protocol": kafka.get_security_protocol(),
        "ssl.ca.location": tls.get_ca_chain_location(),
        "ssl.certificate.location": tls.get_client_certificate_location(),
        "ssl.key.location": tls.get_client_key_location(),
        "group.id": "something"
    }


**Creating Kafka Producer or Consumer**

Once the configuration is set up, you can use the Kafka libraries of your choice. Below is an example of creating a producer and a consumer with the ``kafka-confluent-python`` library, and for creating a consumer using ``pyspark`` streaming.
::

    from hops import kafka
    from hops import tls
    from confluent_kafka import Producer, Consumer

    # -- Using confluent-kafka-python --
    producer = Producer(config)
    consumer = Consumer(config)

    # -- Using pyspark --
    df = spark \
    .format("kafka") \
    .option("kafka.bootstrap.servers", kafka.get_broker_endpoints()) \
    .option("kafka.ssl.truststore.location", tls.get_trust_store()) \
    .option("kafka.ssl.truststore.password", tls.get_key_store_pwd()) \
    .option("kafka.ssl.keystore.location", tls.get_key_store()) \
    .option("kafka.ssl.keystore.password", tls.get_key_store_pwd()) \
    .option("kafka.ssl.key.password", tls.get_trust_store_pwd()) \
    .option("subscribe", TOPIC_NAME) \
    .load()


Once you have created the consumers/producers with the right configuration, you can use the API of your choice to write/read to the Kafka cluster in Hops. Some examples are given here: hops_examples_, and you can find more examples on the documentation pages of respective framework (e.g. ``kafka-confluent-python`` or  ``Spark``)

.. _hops_examples: https://github.com/logicalclocks/hops-examples
.. _API-docs: http://hops-py.logicalclocks.com/

**Getting the schema for a topic**

After you have created a kafka consumer or producer, you might need the schema for the topic you are going to consume/produce to, you can get it from the hops utility library by using the function `get_schema()`.

::

    from hops import kafka
    kafka.get_schema(TOPIC_NAME)
=======
Grid search or genetic hyperparameter optimization such as differential evolution which runs several Experiments in parallel, which we refer to as *Parallel Experiment*.

The library supports ParameterServerStrategy and CollectiveAllReduceStrategy, making multi-machine/multi-gpu training as simple as invoking a function for orchestration. This mode is referred to as *Distributed Training*.

Moreover it provides an easy-to-use API for defining TLS-secured Kafka producers and consumers on the Hops platform.
>>>>>>> Update hops.rst
