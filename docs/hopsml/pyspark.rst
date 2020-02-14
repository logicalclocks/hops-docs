PySpark 
=======

Python Programs as PySpark apps
-------------------------------

Hops uses PySpark to distribute the execution of Python programs in a cluster. PySpark applications consist of two main components, a Driver and one to many Executors. The Driver and the Executors can be started on potentially any host in the cluster and use both the network and the HDFS filesystem to coordinate.


Restructuring Python Programs as PySpark Programs
-------------------------------------------------

If you want to run a Python program, e.g.,  to train a neural network on a GPU on Hops, you will need to restructure your code. The reason for this is that your single Python process needs to be restructured as a PySpark program, see the figure below.

.. _hopsml-pyspark.png: ../_images/hopsml-pyspark.png
.. figure:: ../imgs/hopsml-pyspark.png
    :alt: HopsML Python Program
    :target: `hopsml-pyspark.png`_
    :align: center
    :scale: 25 %
    :figclass: align-center

The good news is that all you will need to do to get started is to move your code inside a function, see table below. You need to define a function - this code will get run on the Executors, and you need to invoke that function from the Driver (the main part of your Python program). 


Logging
-------

Realtime logs can be viewed in either the Spark UI or in Kibana.

When using ``maggy`` or the ``experiment`` module from the ``hops`` library, all the print statements are saved in log files which are then accessible in the Experiments service. In the case of ``maggy``, the Executor logs are written out in real-time to the Jupyter notebook cell that was used to launch the experiment


References
----------

- https://github.com/logicalclocks/hops-examples/blob/master/tensorflow/notebooks/Plotting/Data_Visualizations.ipynb 
- https://github.com/jupyter-incubator/sparkmagic/blob/master/examples/Magics%20in%20IPython%20Kernel.ipynb 


