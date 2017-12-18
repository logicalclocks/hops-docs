===========================
Logs visualization
===========================

HopsWorks aggregates the logs of the applications launched and uses
Kibana for visualization and discovery. To get access to your logs,
upon a job completion, click on the ``Job UI`` button and then on
``Logs`` tab. A sample output for the SparkPi job looks like the
following.

.. _kibana-main.png: ../../_images/kibana-main.png
.. figure:: ../../imgs/kibana-main.png
    :alt: Kibana main
    :target: `kibana-main.png`_
    :align: center
    :figclass: align-center

    Job logs with Kibana

At the top section of the left-hand side of the main screen are the
selected fields of the log that are shown on the main page. At the
bottom section are the rest of the available indexed fields. On the
top is the search bar where you can search for specific fields. For
example if you want to preview the warning messages type
``priority=WARN``. On the right side of the search bar you can save
your search query and load it later.

Also you can visualize certain fields of your logs by clicking on the
`Visualize` button. For example, assume we want to make a pie chart of
the severity of the log messages.

* Step 1: Click on the `Visualize` button
* Step 2: Select the `Pie chart`
* Step 3: Click `From a new search` and select your project's name
  from the drop-down menu
* Step 4: On the `buckets` section click `Split Slices`
* Step 5: The severity level is text so in the `Aggregation` drop-down
  select *Terms* and the `Field` we would like to visualize is the
  *priority* field
* Step 6: Click the green *Play* button on the top

The pie chart should look like the following. On the top right-hand
side is the legend. Hopefully most of your job's messages will be INFO
and a few WARN! On the top right corner is the visualization menu
where you can save, load or share the current chart.

.. _kibana-piechart.png: ../../_images/kibana-piechart.png
.. figure:: ../../imgs/kibana-piechart.png
    :alt: Kibana pie chart
    :target: `kibana-piechart.png`_
    :align: center
    :figclass: align-center

    Kibana visualization
