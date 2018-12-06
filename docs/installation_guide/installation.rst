.. _installation:

Installation
============

.. toctree::
   :maxdepth: 1

   hops-manual-installation-guide
   platforms/cloud.rst
   platforms/baremetal.rst
   platforms/vagrant.rst
   platforms/windows.rst
   platforms/osx.rst
   platforms/cookbooks.rst
   requirements.rst
   upgrades.rst

The Hopsworks stack includes a number of services, but also requires the installation of a number of third-party distributed services:

* Java (OpenJDK or Oracle JRE/JDK)
* Apache Spark
* Apache Flink
* Apache Hive
* TensorFlow/Keras
* MySQL Cluster
* J2EE7 web application server (default: Payara)
* ELK Stack (Elastic, Logstash, Kibana, Filebeat)
* Influxdb, Telegraf, Grafana
* Kafka + Zookeeper
* Apache Zeppelin
* Jupyter Notebook
* Nvidia Cuda/cuDNN/NCCL-2 (if using Nvidia GPUs)
* Apache Airflow
* RStudio
* Apache Livy
* PyTorch
* Conda
  
Due to the complexity of installing and configuring all Hopsworks' services, we recommend installing Hopsworks using the automated installer Karamel/Chef, http://www.karamel.io. We do not provide detailed documentation on the steps for installing and configuring all services in Hopsworks. Instead, Chef cookbooks contain all the installation and configuration steps needed to install and configure Hopsworks. The Chef cookbooks are available at https://github.com/logicalclocks.
