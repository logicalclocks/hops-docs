Horovod on Hops
===============

Horovod programming model in Hops
---------------------------------

To get started with your Horovod coding, you need first to select Horovod in Jupyter configuration on HopsWorks is to first select that mode in the HopsWorks Jupyter configuration.
Keep in mind that the memory allocated for each host will be the memory allocated for all processes on that host, configuring too little memory will result in the Spark Executor being killed.
After starting Jupyter with the Horovod configuration, you can begin coding your TensorFlow code for Horovod.
The modifications that should be done to your code can be found here: https://github.com/uber/horovod#usage

In Jupyter you need to put your the TensorFlow code with the Horovod modifications that you want to run in a single notebook. This notebook should never be run by itself, it will only contain the code that make up your program. The actual launch of the notebook needs to be done from a separate notebook. Behind the scenes the notebook itself will be converted to a .py file and executed on each mpi process.

The Horovod notebook
--------------------

Reading from HDFS
#################

Step 1. The first step is to upload a dataset to your project in HopsWorks. After having uploaded the dataset, your TensorFlow input pipeline code must point to the path in HopsFS where that particular dataset is stored. The first step is to get the root path to your project in HopsFS. This is easily done by the code below.


::

    ... TensorFlow/Horovod code ...

    from hops import hdfs
    project_root_path = hdfs.project_path()

    ... TensorFlow/Horovod code ...
    
The path returned is to the root directory in HopsWorks.

.. figure:: ../../imgs/datasets.png
    :alt: Increasing throughput
    :scale: 100
    :align: center
    :figclass: align-center
    
Step 2. Append the relative path of your dataset to the root path. Assuming you uploaded a file named train.tfrecords in the Resources dataset. The path pointing to that particular dataset would then be.

::

    ... TensorFlow/Horovod code ...

    from hops import hdfs
    project_root_path = hdfs.project_path()
    tfrecords_dataset = project_root_path + "Resources/train.tfrecords"

    ... TensorFlow/Horovod code ...

Step 3. Use the path as any other path in a TensorFlow module

::

    ... TensorFlow/Horovod code ...
    
    dataset = tf.data.TFRecordDataset(tfrecords_dataset)
    
    ... TensorFlow/Horovod code ...

Working with TensorBoard
########################

Every process (or GPU) depending on how you want to think of it. Will run the exact same python script. For this reason, it is import that if you are running any type of checkpointing or writing summaries to TensorBoard, that you wrap that particular code in an if statement where only process 0 performs this action. Otherwise concurrent writes to the same file will corrupt the data.

::

    ... TensorFlow/Horovod code ...

    from hops import tensorboard
    logdir = tensorboard.logdir()

    if hvd.rank() == 0:
        # Checkpointing / TensorBoard code

    ... TensorFlow/Horovod code ...
    

The Launcher notebook
-------------------------------

In this "launcher" notebook you will have to import the allreduce module from the hops library and then call the allreduce.launch function. The first argument is the SparkSession which is created automatically, the second argument is the HDFS path to your notebook containing the Horovod code. 

Example of your launcher notebook, assuming your horovod_program.ipynb is located in the Jupyter dataset in your HopsWorks project.
::

    from hops import hdfs
    notebook_hdfs_path = '/Projects/' + hdfs.project_name() + '/Jupyter/horovod_program.ipynb

    from hops import allreduce
    allreduce.launch(spark, notebook_hdfs_path)

Where do I go from here?
------------------------

We have prepared several notebooks in the TensorFlow tour on HopsWorks with examples for running Horovod on Hops.


Current limitations
-------------------

Horovod on Hops is run on top of Spark. Each host in the mpirun call corresponds to a Spark Executor and the number of processes per host is
as specified in the Jupyter configuration. Currently the support for Horovod only covers one host, supporting multiple hosts is on the roadmap.
The current issue is that mpirun spawns processes on the hosts itself, which means that GPU isolation through Cgroups is not easily achieved, since the isolation is performed
when the Node Manager launches each YARN container. It should be possible to bypass this by making use of the CUDA_VISIBLE_DEVICES environment variable instead and export it for each mpi process.

