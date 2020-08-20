======
Models
======
.. highlight:: python

In the training code models may be exported, typically as a result of a pipeline run. Using the ``hops`` python module it is easy to version and attach meaningful metadata to models to reflect the performance of a given model version. Each project maintains a Model Repository, where all models are listed in addition to useful information such as which user created the model, different versions, time of creation and metadata.
The Model Repository can be queried to find the best version and used to create a new serving or rolling upgrade on an existing one to a new version.

Documentation: hops-py_

Experiment examples: hops-examples_

Exporting model
###############

::

    ... Experiment code producing a model ...

    from hops import model

    # path to directory containing model (e.g. .pb or .pkl) as produced by your code
    local_model_path = os.getcwd() + "/model_dir"

    # uploads contents of local_model_path to Models dataset as model 'mnist' with incrementing version number
    # metadata is set as a dict of metrics through the optional metrics parameter
    model.export(local_model_path, "mnist", metrics={'accuracy': acc})


Querying model repository
############################################

When deploying a model to real-time serving infrastructure or loading a model for offline batch inference, applications can query the model repository to find the best version considering the metadata attached to the model versions such as accuracy.
In the following example the model version for MNIST with the highest accuracy is returned.

::

    from hops import model          # module to export models and query model repository
    from hops.model import Metric   # symbolic class for whether metric should be maximized or minimized
    MODEL_NAME="mnist"              # model name 'mnist'
    EVALUATION_METRIC="accuracy"    # name of the metric

    best_model = model.get_best_model(MODEL_NAME, EVALUATION_METRIC, Metric.MAX)    # query model repository for best model version

    print('Model name: ' + best_model['name'])
    print('Model version: ' + str(best_model['version']))
    print(best_model['metrics'])

    # Outputs
    Model name: mnist
    Model version: 3
    {'accuracy': '0.9098'}


.. _models_service.png: ../_images/models_service.png
.. figure:: ../imgs/models_service.png
   :alt: Dataset browser
   :target: `models_service.png`_
   :align: center
   :figclass: align-center

.. _hops-py: http://hops-py.logicalclocks.com/hops.html#module-hops.model
.. _hops-examples: https://github.com/logicalclocks/hops-examples/tree/master/notebooks/ml/Serving

