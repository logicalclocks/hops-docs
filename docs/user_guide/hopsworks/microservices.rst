=============
Microservices
=============

.. contents:: Contents
   :local:
   :depth: 2
   
Hopsworks makes use of the microservices model to incorporate new services. Each new microservice needs to adhere to the multi-tenant model of Hopsworks based on the concepts of ``Projects`` and ``Users``. 

Adding a new Microservice
-------------------------
There are certain steps required for a new microservice to be integrated into Hopsworks. The following sections describe them on a per application layter basis. 

Front-end
=========
**Angular-JS**

1. Add a new html file in ``/yo/app/views/Microservice.html``
2. Add a new angularJS controller in ``/yo/app/scripts/controllers/MicroserviceCtrl.js``
3. Add a new angularJS service in ``/yo/app/scripts/services/MicroserviceService.js``
4. Add the new service and controller to ``index.html /yo/app/index.html``
5. Add the service as a route to ``app.js`` to route to its URL, e.g.:

   a ``.when('/register', {  ….}``  or 
   
   b ``.when('/project/:projectID/datasets', { …}``
6. Add the new microservice to the array of services defined in projectCreator.js and project.js, as well as the ``/yo/app/navProject.html navigation bar``, and add methods to ``project.js`` for showMicroservice() and goToMicroservice(). 
7. Add the route to the microservice to ``/yo/app/app.js - when('/project/:projectID/tensorflow', {...}``

Chef/Settings updates
=====================
8. Add any new tables used by the microservice to ``hopsworks-chef/templates/default/tables.sql.erb``
9. Add the IP for the new service to the variables table, so that it can be ‘discovered’ by Hopsworks using the Settings.java bean. In the Hopsworks Java web application, you will need to update the Settings.java bean to include the IP addr/port for the new microservice:
  a. ``hopsworks-chef/templates/default/rows.sql.erb``
  b. ``hopsworks/src/main/java/…./Settings.java``
  
Java EE updates
===============
10. Create a new REST service for *Microservice.java*. It should be a subresource of ProjectService.java. Base it on an example, like KafkaService.java
11. Create a new facade MicroserviceFacade.java in the new package io.hops.microservice. The REST service should be a subresource of ProjectService.
12. Add the new REST service to se.kth.rest.application.config.ApplicationConfig.java.
13. Create new Entity beans for the tables defined in step 6. Use the Netbeans wizard to do this - run vagrant and forward port 3306 on mysql to a port you can access. Then connect to the database ‘hopsworks’ with username/password ‘kthfs’/’kthfs’. Make sure to include the full entity name (catalog name) in the definition - ‘hopsworks’.
14. Add the beans to the persistence.xml file in /src/resources/../persistence.xml and the microservice should be added to ProjectServiceEnum.java.

Connect up the components:
    
  a. Javascript - HTML -> Controller -> Service -> …………. 
  b. Java              -> REST-> Facade -> EntityBean

Swagger UI
==========
To visualize and interact with the REST API’s without having to implement the front-end

15. Annotate the REST service with ``@Api(value = "Name of the rest endpoint", description = "description of the rest endpoint")``
16. Build hopsworks-web with  ``mvn clean install -Pswagger-ui`` and deploy
17. Goto ``hopsworks/swagger-ui``
