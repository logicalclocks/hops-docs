================================
Conda environment administration 
================================

Clicking on the *Manage Conda* icon on the admin panel, will lead to Conda administration panel.
In Hopsworks each project has its own Conda environment. Users are free to install whatever library they need without interfering with other projects.

Conda environments are replicated across all the machines of the cluster. When a user requests a new library to be installed in the project environment, Hopsworks records this command in the database and distributed it to all the Kagent processes in the cluster with the Kagent heartbeat protocol.

From the the Conda environment administration page, administrators are able to track which operation is ongoing on which machine. How many Conda operations are scheduled to be executed and are waiting for a previous operation to complete (Conda environment operations are serialized across all projects in the cluster). 

Administrators are also able to see which operations have failed and retry them. This feature requires Hopsworks to be able to SSH into the machines and execute the command. The command output is then displayed for troubleshooting purposes.