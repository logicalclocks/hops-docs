Microsoft Machine Learning for Apache Spark
=========================
.. highlight:: python

What is mmlspark?
-------------------------

MMLSpark provides support for image processing with Apache Spark using OpenCV, enabling you to quickly create powerful, highly-scalable predictive and analytical models for large image datasets. There is also support for Microsoft Cognitive Toolkit (CNTK).
More information can be found at the official Github `repo <https://github.com/Azure/mmlspark>`_


Images API
-----------------

::

    import time
    import mmlspark
    import numpy as np
    from mmlspark import toNDArray
    from mmlspark import ImageTransformer

    IMAGE_PATH = "hdfs:///Projects/labs/hotdog_or_not/seefood/train/hot_dog"
    start_time = time.time()
    images = spark.readImages(IMAGE_PATH, recursive = True, sampleRatio = 1.0).cache()
    images.printSchema()
    print(images.count())
    print("--- %s seconds ---" % (time.time() - start_time))

    tr = (ImageTransformer()                  # images are resized and then cropped
      .setOutputCol("transformed")
      .resize(height = 200, width = 200)
      .crop(0, 0, height = 180, width = 180) )

    small = tr.transform(images).select("transformed")


Starting a Jupyter Notebook with support for mmlspark
-----------------

MMLSpark is pre-installed as a python library for Hopsworks projects. However, it needs the mmlspark.jar file to be installed in Spark's classpath for the driver and executors.
You can install mmlspark.jar by clicking on 'Cluster Setup' before starting Jupyter, and then adding to the 'More Spark Properties' textbox the following on its own line:

::

   spark.jars.packages=Azure:mmlspark:0.11


By default, this will attempt to download the jar file from the maven repository at kompics.sics.se. If you want to access the jar from a different maven repo, you will need to configure the maven repository property of Spark in the 'More Spark Properties' textbox.
