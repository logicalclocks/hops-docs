.. _aws-image:

Amazon Machine Images
=====================

Hopsworks is available as a community AMI ready to be launched. You can use it to
easily create a single-node Hopsworks instance optionally with **dedicated GPU**
for accelerated Deep Learning.

Launch instance
------------------
To launch an EC2 instance with Hopsworks installed, you will need an AWS account.

1. Open Amazon EC2 console https://console.aws.amazon.com/ec2
2. Click **Launch instance**
3. On the **Choose an Amazon Machine Image (AMI)** page, choose **Community AMIs** on the left
4. Search for ``LC-hopsworks-1.4.1`` and select the latest image
5. On the **Choose an Instance Type** page select the hardware configuration for you instance. For a smooth experience we recommend at **minimum** ``t2.2xlarge`` instance type.
6. Continue with configuring **Instance details** Make sure that:

   - The VPC you select has **Private DNS hostnames** enabled. By default when you create a new VPC, it's not enabled. To enabled it follow this guide here_
   - You **Assign a Public IP**

7. Next proceed to **Storage** and we recommend at least 300GB. Note: EBS performance varies by the size of the volume and by usage - the more you use the drive the fastest it gets.
8. In **Configure Security Group** tab make sure you allow at least port **22**. You can also open port **443** to access Hopsworks. Otherwise you must tunnel it using SSH.

.. _here: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-updating

Access Hopsworks
----------------
The instance will be created and automatically initialized. It will take around 5 minutes to initialize Hopsworks.
When the initialization has finished you should be able to access it with your browser at ``https://YOUR_PUBLIC_IP/hopsworks``

As we don't setup a public DNS for your instance, ignore the security warning for the self-signed certificate. The instance
comes preconfigured with administrative login credentials which you **should** change, see :ref:`first_login_no_mfa`.