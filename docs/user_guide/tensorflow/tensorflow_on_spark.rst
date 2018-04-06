TensorFlowOnSpark on Hops
=========================
.. highlight:: python

What is TensorFlowOnSpark
-------------------------

Originally developed by Yahoo, TensorFlowOnSpark is essentially a wrapper for `Distributed TensorFlow <https://www.tensorflow.org/deploy/distributed>`_ and in that sense, TensorFlowOnSpark supports all features which Distributed TensorFlow provides, such as asynchronous or synchronous training.

Improvements by Hops
--------------------

1. **Hops provides GPU scheduling!** In the Jupyter configuration before starting Jupyter in HopsWorks, it is possible to configure the number of GPUs that should be accessible for each worker.

2. **Parameter servers are not allocated any GPUs** since they perform relatively small computations.

3. **GPUs are exclusively allocated**, which mean workers will not crash due to Out-of-memory errors and synchronous training is faster.

Wrap your TensorFlowOnSpark code in a function
----------------------------------------------

The first step is to define a function containing all the logic for your program. This means looking at existing code examples and offical TensorFlowOnSpark documentation.

See the official Github `repo <https://github.com/yahoo/TensorFlowOnSpark>`_

For the original `example <https://github.com/yahoo/TensorFlowOnSpark/tree/master/examples/mnist>`_

Yahoo introduces `TensorFlowOnSpark API <https://www.youtube.com/watch?v=b3lTvTKBatE>`_

The TFCluster API
-----------------

The `TFCluster` python module is used to launch the actual TensorFlowOnSpark program. It is similar to `experiment` in the sense that a wrapper function needs to be created that contains all the TensorFlow code. `TFCluster` provides a `run` function, that amongst other arguments, requires the number of executors and parameter servers to be specified as arguments. The number of executors and parameter servers are specified when you configure Jupyter, to avoid having to specify it twice, these methods will simply detect what you configured and get that value.

::

    from hops import util

    # Get the number of parameter servers and executors configured for Jupyter
    num_param_servers = util.num_param_servers(spark)
    num_executors = util.num_executors(spark)
    
    TFCluster.run(.., num_executors, num_param_servers...)
    
    
Working with TensorBoard
------------------------

When you run your job using TFCluster, TensorBoard will be started automatically. To interact with TensorBoard, import the tensorboard module from the hops python library. In addition to writing summaries and your TensorBoard events of course.

::

    ... TensorFlow code ...

    from hops import tensorboard
    logdir = tensorboard.logdir()

    ... TensorFlow code ...
    
**Navigate to TensorBoard in HopsWorks**
After launching your job using TFCluster, you can monitor training by observing the TensorBoard.

   
.. _jupyter.png: ../../_images/jupyter.png
.. figure:: ../../imgs/jupyter.png
   :alt: Navigate to TensorBoard 1
   :target: `jupyter.png`_
   :align: center
   :figclass: align-center
    
.. _overview.png: ../../_images/overview.png
.. figure:: ../../imgs/overview.png
   :alt: Navigate to TensorBoard 2
   :target: `overview.png`_
   :align: center
   :figclass: align-center
    

Execution Logs
--------------

**Navigate to Logs in HopsWorks**
After launching your job using TFCluster, you can navigate to HopsWorks to see logs from the execution.
   
.. _logs.png: ../../_images/logs.png
.. figure:: ../../imgs/logs.png
   :alt: Logs location
   :target: `logs.png`_
   :align: center
   :figclass: align-center

.. _viewlogs.png: ../../_images/viewlogs.png
.. figure:: ../../imgs/viewlogs.png
   :alt: View execution logs
   :target: `viewlogs.png`_
   :align: center
   :figclass: align-center
   
Where do I go from here?
------------------------

We have prepared several notebooks in the TensorFlow tour on HopsWorks with examples for running TensorFlowOnSpark on Hops.
