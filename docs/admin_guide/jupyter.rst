===============================
Jupyter notebook administration 
===============================

Clicking on the *Jupyter notebook servers* icon will lead to the Jupyter notebook server administration page. From this page administrators can control how many Jupyter notebooks are running and kill any orphan Jupyter server.

Currently there is no global limit on the number of Jupyter notebooks that users can start. In Hopsworks enterprise edition, this is not an issue as Jupyter servers are spread across Kubernetes nodes and new nodes can be added as needed. 
In Hopsworks community edition however, Juptyer servers are started on the same machine as Hopsworks. Depending on the size of the machine and on the cluster layout, a high number of Jupyter notebook might slow down and/or interfere with other services required to run the platform. If this happens, administrators have to take action and reduce the number of open Jupyter notebooks. They can do that form this page by clicking on the delete icon. 

.. _jupyter-1.png: ../_images/admin/jupyter-1.png
.. figure:: ../imgs/admin/jupyter-1.png
   :alt: Edit user 
   :target: `jupyter-1.png`_
   :align: center
   :figclass: align-cente

   Jupyter notebook server administration

The UI shown above displays, for each Jupyter notebook server open, the port on which it is listening, the project it belongs to, the project user who started it, the time at which the Jupyter notebook is going to shutdown and, for the community edition, the process ID of the Jupyter notebook server.

Jupyter notebook servers have an automatic shutdown period (default 6 hours). This to avoid users leaving Jupyter notebook servers open when they are not using it. If a user needs a longer period, he/she can increase the shutdown period.
Hopsworks also has a garbage collection process that checks if a Jupyter notebook server is still running, if not it will automatically remove it from the table.