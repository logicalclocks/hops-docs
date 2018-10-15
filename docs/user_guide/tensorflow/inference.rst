=================
Inference service
=================

Hopsworks provides a REST API for submitting inference requests to the serving server. 
Currently the API only supports, as backend, the TensorFlow model server, but it will be expanded in the future. 

**A word of caution: Please note that the Inference REST API is currently in a beta state. The API is experimental as breaking changes might be introduced in the upcoming releases due to integrating further serving technologies.**

Send a request
--------------

The following is a python skeleton that shows how you can send inference requests to Hopsworks. The skeleton makes uses of the *requests* library. 

.. code-block:: python 

    # Login with Hopsworks using username and password
    credentials = {}
    credentials['email'] = "user@email.com"
    credentials['password'] = "userpassword"

    login_request = requests.post('http://localhost:8080/hopsworks-api/api/auth/login',
                                  data=credentials)

    # Load the data. This example uses mnist. You can download
    # the Python helper script to download the dataset here: 
    # https://github.com/tensorflow/serving/blob/master/tensorflow_serving/example/mnist_input_data.py 
    test_data_set = mnist_input_data.read_data_sets(work_dir).test

    # Get an image from the dataset
    image, label = test_data_set.next_batch(1)

    # Prepare the JSON payload. The format of the payload should respect the format
    # expected by the TensorFlow model server: https://www.tensorflow.org/serving/api_rest
    request_data = {}
    request_data['signature_name'] = 'predict_images'
    request_data['instances'] = image[0].reshape(1, image[0].size).tolist()

    # Send the actual request. The path should be composed as follow:
    # https://<host>:<ip>/hopsworks-api/api/project/hboard<project_id>/models/<model_name>:predict
    r = requests.post("http://localhost:8080/hopsworhboardks-api/api/project/80/models/mnist:predict",
                      cookies=login_request.cookies,hboard
                      data=json.dumps(request_data))hboard



Request Logging
---------------

If during the serving instance creation you have specified a Kafka Topic to log the inference requests, each request will be logged in the topic. 

Inference requests log entries follow this *Avro* schema: 

.. code-block:: json

    {
        "fields": [{
            "name": "modelId", 
            "type": "int"
            },{
            "name": "modelName",
            "type": "string" 
            },{
            "name": "modelVersion",
            "type": "int" 
            },{
            "name": "requestTimestamp",
            "type": "long" 
            },{
            "name": "responseHttpCode",
            "type": "int"
            },{ 
            "name": "inferenceRequest",
            "type": "string"
            },{
            "name": "inferenceResponse",
            "type": "string"
            }],
        "name": "inferencelog",
        "type": "record"
    }

In particular the *inferenceRequest* field contains the payload sent by the client and the *inferenceResponse* contains the answer given by the serving server.

Check out the :doc:`../hopsworks/kafka` documentation and the HopsUtil_ library to learn how you can read the inference logs from the Kafka topic and make the most out of them. 

.. _HopsUtil: https://github.com/logicalclocks/hops-util