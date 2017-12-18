===========================
Apache Zeppelin
===========================

Apache Zeppelin is an interactive notebook web application for running Spark or Flink code on Hops YARN.
You can turn interpreters for Spark/Flink/Pythonetc on and off in the Zeppelin tab, helping, respectively, to reduce time required to execute a Note (paragraph) in Zeppelin or reclaim resources.
More details about Zeppelin can be found at:
https://zeppelin.incubator.apache.org/

To run a job through Zeppelin simply select your project and select
``Zeppelin`` from the project menu. The following screen will appear
where you can create a new notebook and see the status of supported
interpreters.

.. _zeppelin-main.png: ../../_images/zeppelin-main.png
.. figure:: ../../imgs/zeppelin-main.png
    :alt: Zeppelin main
    :target: `zeppelin-main.png`_
    :align: center
    :figclass: align-center

    Zeppelin main

In the following steps we will guide you through running a Zeppelin
tutorial in HopsWorks.

* Step 1: Download the *bank* dataset from `Zeppelin tutorial page`_
* Step 2: Unzip the downloaded file
* Step 3: Select your project and upload the *bank-full.csv* file to
  your dataset using the DataSets browser
* Step 4: Select the uploaded file and copy the file location in HDFS
  shown on top
* Step 5: Click on the ``Zeppelin`` tab from the menu on the left
* Step 6: Create a new notebook
* Step 7: Click on the newly created notebook and you will be
  redirected to Zeppelin where you can write your program. The default
  interpreter is Spark.
* Step 8: Copy the *Data Refine* code snippet from Zeppelin tutorial
  and replace the path to the dataset in HDFS
* Step 9: Click on the `Run` button on the right
* Step 10: Upon successful execution of our job, we move on to *Data
  Retrieval* section of Zeppelin tutorial, where we will visualize our
  data. Paste the code snippets and press the `Run` button. Notice the
  *%sql* header. This snippet will make use of Spark SQL.

.. _Zeppelin tutorial page: https://zeppelin.apache.org/docs/0.5.5-incubating/tutorial/tutorial.html

Your final page should look like the following

.. _zeppelin-tutorial-final.png: ../../_images/zeppelin-tutorial-final.png
.. figure:: ../../imgs/zeppelin-tutorial-final.png
    :alt: Zeppelin tutorial
    :target: `zeppelin-tutorial-final.png`_
    :align: center
    :figclass: align-center

    Zeppelin tutorial

Clicking on the gear on the top right corner as indicated in the
picture below you can change the default interpreter binding. You can
choose among Spark, Livy, Flink, etc just by drag them on the top.

.. _zeppelin-inter.png: ../../_images/zeppelin-inter.png
.. figure:: ../../imgs/zeppelin-inter.png
    :alt: Zeppelin interpreters
    :target: `zeppelin-inter.png`_
    :align: center
    :figclass: align-center

    Zeppelin interpreters
