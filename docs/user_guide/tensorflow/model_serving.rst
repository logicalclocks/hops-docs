========================
TensorFlow Model Serving
========================
.. highlight:: python

HopsWorks supports TensorFlow Serving, a flexible, high-performance serving system for machine learning models, designed for production environments.



Export your model
-----------------

The first step to serving your model is to export it as a servable model. This is typically done using the SavedModelBuilder after having trained your model. For more information please see: https://www.tensorflow.org/serving/serving_basic

Model Serving in Hopsworks
--------------------------
&nbsp;&nbsp;
**Step 1.**

The first step is to train and export a servable TensorFlow model to your Hopsworks project.

To demonstrate this we provide an example notebook which is also included in the TensorFlow tour.
https://github.com/hopshadoop/hops-examples/blob/master/tensorflow/notebooks/Serving/train_and_export_model.ipynb

In order to serve a TensorFlow model on HopsWorks, the .pb file and the variables folder should be placed in the Models dataset in your HopsWorks project. Inside the dataset, the folder structure should mirror what is expected by TensorFlow Serving.

.. figure:: ../../imgs/serving_structure.png
    :alt: Expected Model Serving structure in HDFS
    :scale: 100
    :align: center
    :figclass: align-center
&nbsp;&nbsp;
**Step 2.**

The next step is to create a serving definition in the Hopsworks Model Serving service.


.. figure:: ../../imgs/model_serving.png
    :alt: Model Serving service
    :scale: 100
    :align: center
    :figclass: align-center
    

Click the Model button
    
.. figure:: ../../imgs/serving_definition.png
    :alt: Creating serving definition
    :scale: 100
    :align: center
    :figclass: align-center
    
Select the .pb file in your Models dataset

.. figure:: ../../imgs/select_model.png
    :alt: Select the protobuf model
    :scale: 100
    :align: center
    :figclass: align-center
    
Then select batching if it should be used and create your serving.
&nbsp;&nbsp;
**Step 3.**


After having created the serving definition the next step is to start it.

.. figure:: ../../imgs/created_serving.png
    :alt: Start serving
    :scale: 100
    :align: center
    :figclass: align-center
    
    
After having started successfully the endpoint and logs for the TensorFlow Model server is exposed in the interface.

.. figure:: ../../imgs/running_serving.png
    :alt: Start serving
    :scale: 100
    :align: center
    :figclass: align-center








