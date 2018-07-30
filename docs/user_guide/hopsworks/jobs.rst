===========================
Jobs
===========================

The Jobs tabs is the way to create and run YARN applications. Hopsworks supports the following YARN applications:

* Apache Spark
* Apache Flink
* Adam (a bioinformatics data parallel framework)

If you are a beginner it is **highly** advisable to click on the ``Tours``
button at landing page. It will guide you through launching your
first Spark application!

.. figure:: ../../imgs/guided-tours.png
    :alt: Guided tours
    :scale: 100
    :align: center
    :figclass: align-center

    Guided tours

To run a job upload the required jar files and libraries to your
dataset using the Dataset Browser. Click on the ``Jobs`` tab from the Project Menu and
follow the steps below:

* Step 1: Press the ``New Job`` button on the top left corner
* Step 2: Give a name for you job
* Step 3: Select one of the available job types
* Step 4: Select the jar file with your job that you have uploaded
  earlier
* Step 5: Give the main class and any possible arguments
* (Optional) Step 6: In the *Pre-configuration* you can choose existing
  configurations according to existing jobs history and our
  heuristics
* Step 6: In the *Configure and create* tab you can manually specify
  the configuration you desire for your job and dependencies for the jar
* Step 7: Click on the ``Create job`` button
* Step 8: Click on the ``Run`` button to launch your job

On the right-hand side you can view some information about your job
such as the Spark/Flink dashboard, YARN application UI, logs with
Kibana and metrics with Grafana.

.. figure:: ../../imgs/job-ui.png
    :alt: Job UI
    :scale: 100
    :align: center
    :figclass: align-center

    Job UI

Job logs are available in `Kibana`_ during runtime and are also aggregated once the job is finished. They are available at the bottom of the Jobs page by clicking on
them.

.. _Kibana: logs.html
