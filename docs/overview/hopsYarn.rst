===========================
HopsYarn
===========================

HopsYARN introduces a new metadata layer for Apache YARN, where the cluster state is stored in a distributed, in-memory, transactional database. HopsYARN enables us to provide quotas for Projects, in terms of how many CPU minutes and memory are available for use by each project. Quota-based scheduling is built as a layer on top of the capacity scheduler, enabling us to retain the benefits of the capacity scheduler.

.. figure:: /imgs/hops-yarn.png
   :alt: Hops-YARN Architecture
   :scale: 75
   :width: 600
   :height: 400
   :figclass: align-center

   Hops YARN Architecture.

**Apache Spark**
We support Apache Spark for both interactive analytics and jobs.

**Apache Zeppelin**
Apache Zeppelin is built-in to Hopsworks.
We have extended Zeppelin with access control, ensuring only users in the same project can access and share the same Zeppelin notebooks. We will soon provide source-code control for notebooks using GitHub.

**Apache Flink Streaming**
Apache Flink provides a dataflow processing model and is highly suitable for stream processing. We support it in Hopsworks.

**Apache Kafka**
Apache Kafka is used as a broker for streaming applications. We have
integrated Kafka to our project based model where only members of a
project can produce/consume to/from a specific Kafka topic. Also, with our highly
intuitive UI you can customize ACLs for your topic.

**Other Services**
Hopsworks is a web application that runs on a highly secure Glassfish server. ElasticSearch is used to provide free-text search services. MySQL
