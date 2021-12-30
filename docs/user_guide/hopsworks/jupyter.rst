Jupyter Notebooks
=======================

The documentation for the Jupyter notebooks, except for the *Jupyter notebooks with version control* section, has moved to https://docs.hopsworks.ai

Jupyter notebooks with version control
--------------------------------------

Jupyter notebooks have become the lingua franca for data scientists. As with ordinary source code files, we should version them
to be able to keep track of the changes we made or collaborate.

**Hopsworks Enterprise Edition** comes with a feature to allow users to version their notebooks with Git and interact with remote repositories such as
GitHub ones. Authenticating against a remote service is done using API keys which are safely stored in Hopsworks.

Getting an API key
~~~~~~~~~~~~~~~~~~

The first thing we need to do is issue an API key from a remote hosting service. For the purpose of this guide it will be GitHub.
To do so, go to your **Settings** > **Developer Settings** > **Personal access tokens**

Then click on **Generate new token**. Give a distinctive name to the token and select all repo scopes. Finally hit the **Generate token button**.
For more detailed instructions follow `GitHub Help <https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line>`_.

.. _github_api_key.png: ../../_images/github_api_key.png
.. figure:: ../../imgs/jupyterlab_git/github_api_key.png
    :alt: Generate API key in GitHub
    :target: `github_api_key.png`_
    :align: center
    :figclass: align-center

    Issuing an API key from GitHub

**NOTE:** Make sure you copy the token, if you lose it there is no way to recover, you have to go through the steps again

Storing API key to Hopsworks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once we have issued an API key, we need to store it in Hopsworks for later usage. For this purpose we will use the *Secrets* which
store encrypted information accessible only to the owner of the secret. If you wish to, you can share the same secret API key with
all the members of a Project.

Go to your account’s **Settings** on the top right corner and click **Secrets**.
Give a name to the secret, paste the API token from the previous step and finally click **Add**.

.. _hopsworks_secrets.png: ../../_images/hopsworks_secrets.png
.. figure:: ../../imgs/jupyterlab_git/hopsworks_secrets.png
    :alt: Store API key in Hopsworks
    :target: `hopsworks_secrets.png`_
    :align: center
    :figclass: align-center

    Storing the API key as secret in Hopsworks

Starting Jupyter with Git
~~~~~~~~~~~~~~~~~~~~~~~~~

To start versioning your Jupyter notebooks is quite trivial. First copy the web URL of your repository from GitHub or GitLab.

.. _github_copy_url.png: ../../_images/_github_copy_url.png
.. figure:: ../../imgs/jupyterlab_git/github_copy_url.png
    :alt: Copy repository web URL
    :target: `github_copy_url.png`_
    :align: center
    :figclass: align-center

    Copy repository web URL from GitHub

Navigate into a Project and head over to Jupyter from the left panel. Regardless of the mode, Git options are the same. For
brevity, here we use Python mode. Expand the **Advanced configuration** and enable **Git** by choosing **GITHUB** or **GITLAB**, here we use GitHub. More options will appear as shown in figure
below. Paste the repository's web URL from the previous step into *GitHub repository URL* and from the *API key* dropdown select
the name of the *Secret* you entered.

.. _launch_jupyter_git.png: ../../_images/launch_jupyter_git.svg
.. figure:: ../../imgs/jupyterlab_git/launch_jupyter_git.svg
    :alt: Launching JupyterLab with Git integration
    :target: `launch_jupyter_git.png`_
    :align: center
    :figclass: align-center

    Launching JupyterLab with Git integration

Keep in mind that once you've enabled Git, you will **no longer be able** to see notebooks stored in HDFS and vice versa. Notebooks
versioned with Git will **not** be visible in Datasets browser. Another important note is that if you are running Jupyter Servers on Kubernetes
and Git is enabled, notebooks are stored in the pod's local filesystem. So, if you stop Jupyter or the pod gets killed and you haven't **pushed**,
your modifications will be lost.

That’s the minimum configuration you should have. It will pick the default branch you've set in GitHub and set it as *base* and *head* branch.
By default it will automatically **pull** from *base* on Jupyter startup and **push** to *head* on Jupyter shutdown.
You can change this behaviour by toggling the respective switches. Click on the *plus button* to create a new branch to commit your changes and
push to remote.

Finally hit the **Start** button on the top right corner!

From within JupyterLab you can perform all the common git operations such as diff a file, commit your changes, see the history of your branch,
pull from a remote or push to a remote etc. For more complicated operations you can always fall back to good old terminal.

.. _jupyterlab_git.gif: ../../_images/jupyterlab_git.gif
.. figure:: ../../imgs/jupyterlab_git/jupyterlab_git.gif
    :alt: JupyterLab with Git integration
    :target: `jupyterlab_git.gif`_
    :align: center
    :figclass: align-center

    Notebooks version control


Want to Learn More?
---------------------------------------------------------

We have provided a large number of example notebooks, available here_. Go to Hopsworks and try them out! You can do this either by taking one of the built-in *tours* on Hopsworks, or by uploading one of the example notebooks to your project and run it through the Jupyter service. You can also have a look at HopsML_, which enables large-scale distributed deep learning on Hops.

.. _here: https://github.com/logicalclocks/hops-examples
.. _HopsML: ../../hopsml/hopsML.html
.. _sparkmagic: https://github.com/jupyter-incubator/sparkmagic
.. _livy: https://github.com/apache/incubator-livy
