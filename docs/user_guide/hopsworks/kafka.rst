===========================
Apache Kafka
===========================


In HopsWorks we provide Kafka-as-a-Service for streaming
applications. In the following section we will guide you through
creating a *Producer* job which will produce in a Kafka topic and a
simple *Consumer* job which will consume from that topic. Our service
is tightly coupled with our project-based model so only members of a
project can use a specific Kafka topic, unless specified as we see
later on.

To begin with you have to download and compile our utilities library
which will abstract away all the configuration boilerplate code such
as Kafka endpoints, topics etc

* Step 1: `git clone git@github.com:hopshadoop/hops-util.git` to clone
  the library
* Step 2: `cd hops-util/ && mvn package` to build it

Then you need to download and compile a sample Spark
streaming application.

* Step 1: `git clone
  git@github.com:hopshadoop/hops-kafka-examples.git` to clone our
  sample application
* Step 2: `cd hops-kafka-examples/ && mvn package` to build the
  project

Next step is to create a Kafka topic at HopsWorks that our application
will produce to and consume from.

* Step 1: From the project box on the landing page, select a project
* Step 2: Click on the `Kafka` tab and the topics page will appear

.. figure:: ../../imgs/kafka-schemas.png
    :alt: Kafka topics
    :scale: 100
    :align: center
    :figclass: align-center

    Kafka topics & schemas

* Step 3: First we need to create a schema for our topic, so click on
  the `Schemas` tab and `New Avro Schema`. Copy the sample schema from
  `here`_ and paste it in the `Content` box. Click on the `Validate`
  button to validate the schema you provided and then `Create`.

* Step 4: Click on `New Topic`, give a topic name, select the
  schema you created at Step 3 and press `Create`.

* Step 5: Upload `hops-kafka-examples/spark/target/hops-spark-0.1.jar`
  and `hops-util/target/hops-util-0.1.jar` to a dataset

* Step 6: Click on the `Jobs` tabs at project menu and follow the
  instructions from the **Jobs** section. Create a new job for the
  Producer. Select `Spark` as job type and `hops-kafka-0.1.jar` as JAR
  file. The name of the main class is
  `io.hops.examples.spark.kafka.StreamingExample` and argument is
  `producer`. At the `Configure and create` tab, click on `Kafka`
  Services and select the Kafka topic you created at Step 4. Your job
  page should look like the following

.. _kafka-producer.png: ../../_images/kafka-producer.png
.. figure:: ../../imgs/kafka-producer.png
    :alt: Kafka producer job
    :target: `kafka-producer.png`_
    :align: center
    :figclass: align-center

    Kafka producer job

* Step 7: We repeat the instructions on Step 6 for the Consumer
  job. Type a different job name and as argument to the main class
  pass `consumer /Projects/YOUR_PROJECT_NAME/Resources/Data`. The rest
  remain the same as the Producer job.

* Step 8: `Run` both jobs. While the consumer is running you can check
  its execution log. Use the Dataset browser to navigate to the
  directory `/Resources/Data-APPLICATION_ID/`. Right click on the file
  `part-00000` and *Preview* the content.

  A sample output would look like the following

.. figure:: ../../imgs/kafka-sink.png
    :alt: Kafka ouput
    :scale: 100
    :align: center
    :figclass: align-center

    Kafka output

.. _here: https://github.com/hopshadoop/hops-kafka-examples/tree/master/spark

A Kafka topic by default will be accessible only to members of a
specific project. In order to *share* the topic with another project
click on the ``Kafka`` service from the menu on the left. This will
bring you to Kafka main page as illustrated below. Then press the
the ``Share topic`` button on the appropriate topic and select the
name of the project you would like to share with.

.. figure:: ../../imgs/kafka-main.png
    :alt: Kafka main
    :scale: 100
    :align: center
    :figclass: align-center

    Kafka main page

You can also fine grain access to Kafka topics by adding ACLs easily
through our UI. Once you have created a Kafka topic, click on the
``Kafka`` service and then on the *Add new ACL* button.

When creating a new ACL you are given the following options:

* **Permission Type** - Whether you will *allow* or *deny* access
  according to the ACL you are about to create

* **Operation Type** - The operation this ACL will affect:

  * *read* : Read from the topic
  * *write* : Write to the topic
  * *detail* : Get information about this topic
  * \* : All above

* **Role** - The user role this ACL will affect. It can be *Data
  scientist*, *Data owner* or both.

* **Host** - Originating host of the request to read, write or detail

* **Project name** - The name of project this ACL concerns in case you
  have shared the topic with another project

* **Member email** - Email of the user that this ACL will apply or *
  for everybody

When you are done with the ACL parameters click on the `Create`
button.

As an example assume that we have already created a Kafka topic for
our project and we have shared this topic with another project named
`another_sample_project`. We would like members of the other project
**NOT** to be able to produce on this topic. Then the ACL would look
like the following.

.. figure:: ../../imgs/kafka-acl-example.png
    :alt: Kafka acl example
    :scale: 100
    :align: center
    :figclass: align-center

    Kafka ACL example

If you would like to see more details about your Kafka topic click on
the ``Advanced view`` button. In the picture below we
can see that there are three ACLs. The first is the default ACL which
is applied when a topic is created. The second was created when we
shared the topic with another project, allowing full access and
finally the third is the custom ACL we created before.

.. figure:: ../../imgs/kafka-topic-details.png
    :alt: Kafka topic details
    :scale: 100
    :align: center
    :figclass: align-center

    Kafka topic details
