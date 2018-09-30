================================
Hops Amazon Machine Image (AMI)
================================

We provide an Amazon Machine Instance (AMI) of the latest version of the Hops Platform. To start using the AMI log into your AWS account (or create a new one). 

Launch a new EC2 instance. The first step requires you to select the AMI. Select `Community AMIs` and search for `hops-ami`. Select it and progress with the launch. 
Currently the AMI is not configured to use GPUs. So you can run the AMI on instances of type T (general purpose) or C (compute optimized). Make sure the instance you launch has at least 16 GB of memory and 4 vCpus.
Give your instance at least 40 GB of disk and make sure the security group allows incoming traffic on port 80.
Once you are done with the configuration, you can launch you instance.

Please refer to the AWS documentation_ for more information on how to launch a EC2 instance: 

.. _documentation: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/launching-instance.html

Once your instance has started, ssh into it. In the home directory of the `ubuntu` user you will find a script called `start-services.sh`. Run that script to launch all the services and start using the platform. 

Once all the services are up and running, open the browser and visit `http://<public_ip>/hopsworks` where `public_ip` is the public ip of your 
instance which you can find on the AWS console.

You can log into Hopsworks using the following credentials:

- username : admin@kth.se
- password : admin

You can now use the platform. For more information on the different services the platform offers see :doc:`/user_guide/hopsworks`