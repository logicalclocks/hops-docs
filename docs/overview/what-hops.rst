===========================
What is Hopsworks?
===========================

Hopsworks is a full-stack platform for scale-out data science, with support for both GPUs and Big Data, in a familiar development environment. Hopsworks unique features are:

* a user-friendly UI for Developing with the latest open-source platforms for Data Science (Jupyter, Conda, etc),
* Github-like Projects to manage teams/products/workflows/data,
* managed GPUs as a Resources - scale out Deep Learning training and hyperparameter optimization,
* the world's fastest, most-scalable distributed hierarchical filesystem.
* a REST API for the whole Hopsworks Platform,
* a TLS Certificate based security model with extensive auditing and data provenance capabilities,
* end-to-end support for Python-based Deep Learning workflows with: a Feature Store, Data and Model Validation, Model Serving on Kubernetes, workflow orchestration in Airflow.

Hopsworks supports the following open-source platforms for Data Science:

* development: Jupyter, plugin to IDEs (vi the REST API), Conda/Pip;
* machine learning frameworks: TensorFlow, Keras, PyTorch, ScikitLearn;  
* data analytics and BI: SparkSQL, Hive;
* stream processing: Spark streaming, Flink, Kafka;
* model serving: Kubernetes/Docker.


Projects
=====================  


.. figure:: ../imgs/projects/hopsworks-projects-medium.png
  :alt: Projects in Hopsworks
  :scale: 60
  :figclass: align-center

  Just like Github is made up of repositories, Hopsworks is made up of lots of *Projects*. A Project is, in turn, a collection of users, data assets, and programs (code). 


.. figure:: ../imgs/projects/hopsworks-projects-detailed.png
  :alt: Detailed view of Projects in Hopsworks
  :scale: 60
  :figclass: align-center

  Projects also have quotas associated with them - CPU/GPU and how much data they can store.
  

 
  

Unified Scale-Out Metadata
=======================

.. figure:: ../imgs/projects/hopsworks-metadata-layer.png
  :alt: Scale-out Metadata in Hopsworks
  :scale: 60
  :figclass: align-center

  Hopsworks is enabled by a unified, scale-out metadata layer - a strongly consistent in-memory data layer that stores metadata for everything from Projects in Hopsworks, Filesystem metadata, Kafka ACLs, and YARN quota information.
