===========================
What is Hops?
===========================

Hops is a next-generation distribution of Apache Hadoop that supports:

* Hadoop-as-a-Service,
* Project-Based Multi-Tenancy,
* Secure sharing of DataSets across projects,
* Extensible metadata that supports free-text search using Elasticsearch,
* YARN quotas for projects.

The key innovation that enables these features is a new architecture for scale-out, consistent metadata for both the Hadoop Filesystem (HDFS) and YARN (Hadoop's Resource Manager). The new metadata layer enables us to support multiple stateless NameNodes and TBs of metadata stored in MySQL Cluster Network Database (NDB). NDB is a distributed, relational, in-memory, open-source database. This enabled us to provide services such as tools for designing extended metadata (whose integrity with filesystem data is ensured through foreign keys in the database), and also extending HDFS' metadata to enable new features such as erasure-coded replication, reducing storage requirements by 50\% compared to triple replication in Apache HDFS. Extended metadata has enabled us to implement quota-based scheduling for YARN, where projects can be given quotas of CPU hours/minutes and memory, thus enabling resource usage in Hadoop-as-a-Service to be accounted and enforced.

Hops builds on YARN to provide support for application and resource management. All YARN frameworks can run on Hops, but currently we only provide UI support for general data-parallel processing frameworks such as Apache Spark, Apache Flink, and MapReduce. We also support frameworks used by BiobankCloud for data-parallel bioinformatics workflows, including SAASFEE and Adam. In future, other frameworks will be added to the mix.
