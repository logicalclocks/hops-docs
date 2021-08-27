.. _inference:

=========
Inference
=========

Hopsworks provides a REST API for submitting inference requests to the serving servers. Currently the API supports, as backend, the TensorFlow model server and Flask Servers for Models trained with python-based frameworks such as Sklearn or XGBoost.


Limitations
-----------

Using the REST API provided by Hopsworks for inference is the recommended approach. TensorFlow Serving Server also supports grpc which requires the ``tensorflow-serving-api`` python client. We have noticed that installing that library may lead to not being able to export the Anaconda environment for the project.


Send a request
--------------

The code snippet below shows how you can send 20 inference requests to Hopsworks for a Tensorflow Serving Server serving a model with the name "mnist" that expects a vector of shape 784 as input.

.. code-block:: python

    from hops import serving
    for i in range(20):
        data = {
                    "signature_name": 'predict_images',
                    "instances": [np.random.rand(784).tolist()]
                }
        response = serving.make_inference_request("mnist", data)


The code snippet below shows how you can send 20 inference requests to Hopsworks for a Flask Server serving a SkLearn model with the name "IrisFlowerClassifier" that expects a vector of shape 4 as input.

.. code-block:: python

    from hops import serving
    for i in range(20):
        data = {"inputs" : [[random.uniform(1, 8) for i in range(4)]]}
        response = serving.make_inference_request("IrisFlowerClassifier", data)



Requests Logging
-----------------

If during the serving instance creation you have specified a Kafka Topic to log the inference requests, each request will be logged in the topic.

Inference requests log entries can follow two different *Avro* schemas depending on the serving tool used to deploy the model server. If the serving instance is deployed using Docker or Kubernetes, the inference requests log entries will follow the *Avro* schema:

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
            },{
            "name": "modelServer",
            "type": "string"
            },{
            "name": "servingTool",
            "type": "string"
            }],
        "name": "inferencelog",
        "type": "record"
    }
    
In particular the *inferenceRequest* field contains the payload sent by the client and the *inferenceResponse* contains the answer given by the serving server.

By contrast, if the serving instance is deployed using KFServing, the inference requests log entries will follow the *Avro* schema below, where requests and responses are logged separately:

.. code-block:: json

    {
        "fields": [{
            "name": "servingId",
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
            "name": "inferenceId",
            "type": "string"
            },{
            "name": "messageType",
            "type": "string"
            },{
            "name": "payload",
            "type": "string"
            }],
        "name": "inferencelog",
        "type": "record"
    }

In this case, each log entry contains a unique *inferenceId* that allows you to match requests with the corresponding responses. A *messageType* field indicates whether the log entry is *Request* or *Response* and the *payload* field contains the content of the event (i.e model input or predictions).

Below is a python code-snippet showing how you can read 10 inference logs from Kafka for a Serving Instance with the name "mnist":

.. code-block:: python

    from hops import serving, kafka
    from confluent_kafka import Producer, Consumer, KafkaError
    topic = serving.get_kafka_topic("IrisFlowerClassifier")
    config = kafka.get_kafka_default_config()
    config['default.topic.config'] = {'auto.offset.reset': 'earliest'}
    consumer = Consumer(config)
    topics = [topic]
    consumer.subscribe(topics)
    json_schema = kafka.get_schema(topic)
    avro_schema = kafka.convert_json_schema_to_avro(json_schema)

    for i in range(0, 10):
        msg = consumer.poll(timeout=1.5)
        if msg is not None:
            value = msg.value()
            event_dict = kafka.parse_avro_msg(value, avro_schema)



Check out our Kafka documentation under User Guide, the hops-util-py_ and HopsUtil_ libraries to learn more about how you
can read the inference logs from the Kafka topic and make the most out of them. Example notebooks are available here_.

.. _hops-util-py: https://github.com/logicalclocks/hops-util-py
.. _HopsUtil: https://github.com/logicalclocks/hops-util
.. _here: https://github.com/logicalclocks/hops-examples
