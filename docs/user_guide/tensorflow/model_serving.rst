========================
TensorFlow Model Serving
========================
.. highlight:: python

HopsWorks supports TensorFlow Serving, a flexible, high-performance serving system for machine learning models, designed for production environments.



Export your model
-----------------

The first step to serving your model is to export it as a servable model. This is typically done using the SavedModelBuilder after having trained your model. For more information please see: https://www.tensorflow.org/serving/serving_basic

We provide the basic serving tutorial in contained in two notebooks which makes use of the same code as the official tutorial.

In order to serve a TensorFlow model on HopsWorks, the .pb file and the variables folder should be placed in the Models dataset in your HopsWorks project. Inside the dataset, the folder structure should mirror what is expected by TensorFlow Serving. SHOW PICTURE OF STRUCTURE



Start serving in HopsWorks
--------------------------

In HopsWorks 


