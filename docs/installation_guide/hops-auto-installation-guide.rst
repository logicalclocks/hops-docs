.. _hops-auto-install:

Hops Automated installation
===========================
The Hops stack includes a number of services, also requires a number of third-party distributed services:

* Java (OpenJDK or Oracle JRE/JDK)
* Apache Spark
* Apache Flink
* TensorFlow    
* MySQL Cluster
* J2EE7 web application server (default: Payara)
* ElasticSearch
* Kafka
* Zookeeper
* Apache Zeepelin
* Jupyter Notebook
* Nvidia Cuda/cuDNN/NCCL-2 (if using Nvidia GPUs)
  
Due to the complexity of installing and configuring all Hops' services, we recommend installing Hops using the automated installer Karamel/Chef (http://www.karamel.io). We do not provide detailed documentation on the steps for installing and configuring all services in Hops. Instead, Chef cookbooks contain all the installation and configuration steps needed to install and configure Hops. The Chef cookbooks are available at: https://github.com/hopshadoop.
