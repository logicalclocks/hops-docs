Integrating with AWS SageMaker
==============================

Connecting from Amazon SageMaker
--------------------------------

Connecting to the Feature Store from Amazon SageMaker requires a Feature Store API key to be stored in the AWS Parameter Store or Secrets Manager. Additionally, read access to this API key needs to be given to the AWS role used by SageMaker and hopsworks-cloud-sdk needs to be installed on SageMaker.


**Generating an API Key and storing it in the AWS Secrets Manager**

In Hopsworks, click on your username in the top-right corner and select *Settings* to open the user settings. Select *Api keys*. Give the key a name and select the *featurestore* and *project* scopes before creating the key. Copy the key into your clipboard for the next step.

.. _hopsworks_api_key.png: ../../_images/api_key.png
.. figure:: ../../imgs/cloud/api_key.png
    :alt: Hopsworks feature store api key
    :target: `hopsworks_api_key.png`_
    :align: center
    :scale: 30 %
    :figclass: align-center

**(Alternative 1, step 1) Storing the API Key in the AWS Systems Manager Parameter Store**

In the AWS management console ensure that your active region is the region you use for SageMaker. Go to the *AWS Systems Manager* choose *Parameter Store* and select *Create Parameter*. As name enter */hopsworks/role/[MY_SAGEMAKER_ROLE]/type/api-key* replacing [MY_SAGEMAKER_ROLE] with the AWS role used by the SageMaker instance that should access the Feature Store. Select *Secure String* as type and create the parameter.

.. _hopsworks_parameter_store.png: ../../_images/parameter_store.png
.. figure:: ../../imgs/cloud/parameter_store.png
    :alt: Hopsworks feature store parameter store
    :target: `hopsworks_parameter_store.png`_
    :align: center
    :scale: 20 %
    :figclass: align-center

**(Alternative 1 step 2) Granting access to the secret to the SageMaker notebook role**

In the AWS management console go to *IAM*, select *Roles* and then the role that is used when creating SageMaker notebook instances. Select *Add inline policy*. Choose *Systems Manager* as service, expand the *Read* access level and check *GetParameter*. Expand Resources and select *Add ARN*. Fill in the region of the *Systems Manager* as well as the name of the parameter **WITHOUT the leading slash** e.g. *hopsworks/role/[MY_SAGEMAKER_ROLE]/type/api-key* and click *Add*. Click on *Review*, give the policy a name und click on *Create policy*.

.. _hopsworks_aws_policy2.png: ../../_images/aws_policy2.png
.. figure:: ../../imgs/cloud/aws_policy2.png
    :alt: Hopsworks feature store set policy
    :target: `hopsworks_aws_policy2.png`_
    :align: center
    :scale: 30 %
    :figclass: align-center

**(Alternative 2 step 1) Storing the API Key in the AWS Secrets Manager**

In the AWS management console ensure that your active region is the region you use for SageMaker. Go to the *AWS Secrets Manager* and select *Store new secret*. Select *Other type of secrets* and add *api-key* as the key and paste the API key created in the previous step as the value. Click next.

.. _hopsworks_secrets_manager.png: ../../_images/secrets_manager.png
.. figure:: ../../imgs/cloud/secrets_manager.png
    :alt: Hopsworks feature store secrets manager step 1
    :target: `hopsworks_secrets_manager.png`_
    :align: center
    :scale: 20 %
    :figclass: align-center

As secret name enter *hopsworks/role/[MY_SAGEMAKER_ROLE]* replacing [MY_SAGEMAKER_ROLE] with the AWS role used by the SageMaker instance that should access the Feature Store. Select next twice and finally store the secret. Then click on the secret in the secrets list and take note of the *Secret ARN*.

.. _hopsworks_secrets_manager2.png: ../../_images/secrets_manager2.png
.. figure:: ../../imgs/cloud/secrets_manager2.png
    :alt: Hopsworks feature store secrets manager step 2
    :target: `hopsworks_secrets_manager2.png`_
    :align: center
    :scale: 30 %
    :figclass: align-center

**(Alternative 2 step 2) Granting access to the secret to the SageMaker notebook role**

In the AWS management console go to *IAM*, select *Roles* and then the role that is used when creating SageMaker notebook instances. Select *Add inline policy*. Choose *Secrets Manager* as service, expand the *Read* access level and check *GetSecretValue*. Expand Resources and select *Add ARN*. Paste the ARN of the secret created in the previous step. Click on *Review*, give the policy a name und click on *Create policy*.

.. _hopsworks_aws_policy.png: ../../_images/aws_policy.png
.. figure:: ../../imgs/cloud/aws_policy.png
    :alt: Hopsworks feature store set policy
    :target: `hopsworks_aws_policy.png`_
    :align: center
    :scale: 30 %
    :figclass: align-center

**Installing hopsworks-cloud-sdk and connecting to the Feature Store**

To be able to access the Hopsworks Feature Store, the hopsworks-cloud-sdk library needs to be installed. One way of achieving this is by opening a Python notebook in SageMaker and installing the latest hopsworks-cloud-sdk. Note that the library will not be persistent. For information around how to permanently install a library to Sagemaker see `Install External Libraries and Kernels in Notebook Instances <https://docs.aws.amazon.com/sagemaker/latest/dg/nbi-add-external.html>`_. ::

    !pip install hopsworks-cloud-sdk

You can now connect to the Feature Store::

    import hops.featurestore as fs
    fs.connect('my_instance.us-east-2.compute.amazonaws.com', 'my_project', secrets_store = 'secretsmanager')

If you have trouble connecting, then ensure that the Security Group of your Hopsworks instance on AWS is configured to allow incoming traffic from your SageMaker instance. See `VPC Security Groups <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html>`_. for more information. If your Sagemaker instances are not in the same VPC as your Hopsworks instance and the Hopsworks instance is not accessible from the internet then you will need to configure `VPC Peering on AWS <https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html>`_.