=====================
Nodes administration
=====================

Clicking on the *Manage cluster Nodes* icon on the admin panel, will lead you to the node management panel.
From here the administrator able to get an overview of the nodes in the cluster.

For each node the page displays:

- Hostname:
    It either contains the value specified by the administrator when they added the node, or, if the node was provisioned with Karamel/Chef, it contains the value of the attribute `node['fqdn']` provided by Ohai_. 
    Be aware that the hostname value in the cluster nodes UI should match the `hostname` and `host-id` values in Kagent `config.ini` configuration file on the node. 

- Public IP (if any):
    Default is empty, can be configured by the administrator. 

- Private IP
    It either contains the value specified by the administrator when they added the node, or, if the node was provisioned with Karamel/Chef, it contains the value of the attribute `node['private_ip']` derived from the cluster definition. 
    As for the Hostname, the value diplayed in Hopsworks should match the value in Kagent `config.ini` configuration file. 

- Agent password
    Random generated password used by Hopsworks to authenticate with the Kagent webserver running on the node and to send command to execute (Example: restart a service).

- Registration status
    Before being part of the cluster, each node, through Kagent should register with Hopsworks. This process includes the generation and sign of the node's X.509 certificate. 
    The registration status flag indicates if this process was successfull for the specific host.

- Conda activation status
    Hopsworks uses Kagent to create and update, on each node of the cluster, the Conda environments for the projects. 
    If a node doesn't run a Nodemanager or it has to be taken offline for maintenance, administrators can disable Conda for the specific node. This has the effect that Conda operations won't be scheduled for that node.
    Please be aware that when the node is taken back online a manual sync of the Conda environments is required.

- Health 
    This field displays the health status of the node. The health is good if Kagent detects that all the services are running. 
    The page includes also the time elapsed since Kagent heartbeated last.

- Number of Cores
    Displays the number of cores as detected by Kagent

- Memory 
    Displays the amount of memory as detected by Kagent

- Number of GPUs
    Display the number of GPUs as detected by Kagent

Add a new node
--------------

We encourage administrator to provision new nodes using Karamel/Chef. However, in case the administrator wants to include an already provisioned node in the cluster, a button to `Add new node` is available.

Clicking on the button will show a pop up to insert the hostname and the private IP of the node the administrator wants to include.

Once the node has been added in Hopsworks, the administrator should instruct Kagent to register. To do so, he/she should edit Kagent's configuration file (Default `/srv/hops/kagent/etc/config.ini`) and run the `/srv/hops/kagent/host-certs/run_csr.sh` script. The script will register with Hopsworks and get a valid X.509 certificate for the host.
When the process is done, the administrator can start the remaining servers.

Rotate host keys
----------------

By default hosts certificate have a 10 years validity period. However, we encourage administrators to preiodically rotate the certificates. To rotate the certificates of one or more hosts, administrators can select the desired hosts in the UI and click the `Rotate host keys` button. 

This will have the effect of generating a new certificate for each host and sign it with the Hopsworks CA. Hopsworks services will pick up the new certificate automatically.


Kagent lifecycle
----------------

In case the Kagent process crashes or becomes unresponsive on a node, it is possible to restart it from the node management panel.
Administrators can select the nodes for which they want to restart Kagent and click on the `Restart Kagent` button. 
Please be aware that this feature relies on SSH. Hopsworks needs to be able to SSH into the selected node and restart the process. SSH keys are automatically setup by Karamel/Chef during deployment, however your infrastructure might not allow SSH using keys and/or limit the list of users that can SSH into the nodes.

Hopsworks can also be configured to automatically monitor the state of the Kagent processes and restart them in case they fail to heartbeat for a configurable period of time.
Administrators can enable this feature by specifying the following attributes in the cluster definition:

.. code-block:: yaml

  hopsworks:
    kagent_liveness:
      enabled: true
      threshold: "40s"

As for the start, stop and restart button, this feature relies on Hopsworks being able to SSH into the nodes. 

.. _Ohai: https://docs.chef.io/ohai.html