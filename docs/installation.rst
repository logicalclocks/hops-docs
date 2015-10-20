******************
Installation
******************
The Hops stack includes a number of services also requires a number of third-party distributed services:
* Java 1.7 (OpenJDK or Oracle JRE/JDK)
* NDB 7.4+ (MySQl Cluster)
* J2EE7 web application server (Glassfish by default)
* ElasticSearch 1.7+
  
  Due to the complexity of installing and configuring all Hops' services, we recommend installing Hops using the automated installer Karamel/Chef.
  We do not provide documentation for installing and configuring all services. For the curious, the Chef cookbooks that install our services are available at: https://github.com/hopshadoop.

Amazon Web Services (EC2)
===========

Google Compute Engine (GCE)
===========

OpenStack
===========



Linux On-Premises
===========





Ubuntu/Debian
-------------

Centos/Redhat
-------------



Windows
===========

Install HopsWorks and Hops with Vagrant::

    $ git clone https://github.com/hopshadoop/hopsworks-chef.git
    $ cd hopsworks-chef
    $ berks vendor cookbooks
    $ vagrant up


Install HopsWorks and Hops for AWS(EC2), GCE, OpenStack, or On-Premises (with Chef/Karamel)::

    $ wget https://github.com/hopshadoop/hopsworks-chef.git



Mac
===========

