====================
Platform Testing
====================

Developer Guide
----------------

Each pull request to HopsWorks or one of the cookbooks needs to be tested before merging it into the master branch.
The tests test the correct functioning of the platform as whole, this means that each time tests are triggered the following steps will be executed:

* Spin up a set of new VMs with different configuration
* Clone and build HopsWorks
* Deploy the platform
* Run the tests

A failure in building/deployment or testing will fail the entire Jenkins build.

Triggering the tests is trivial. Besides having a fork of the HopsWorks repo and of all the cookbook repos, developers should also have a fork of the ``hops-testing`` repo_.

Once developers are satisfied with their changes, they should open all the PRs necessary to merge their work upstream. In case of cookbooks PR, the links in the Berksfiles should *always* point to master.

They should open also a new PR on the ``hops-testing`` repo. This last PR should modify the ``test_manifesto`` file which contains the list of repos the change involves.

The format for this file should be::

    organization/reponame/branch
    organization/reponame/branch

Where *organization* is the developer's GitHub username, *reponame* is the repository name and *branch* is the branch which contains the changes.
The ``test_manifesto`` makes sure that all the PRs related to a single change are tested together.

The PR on the ``hops-testing`` repo will be picked up by Jenkins which will start the tests.

Please add a comment to each PR in the other repos with the link of the ``hops-testing`` PR, so it will be easier for maintainers to check your PRs and merge them.

.. _repo: https://github.com/hopshadoop/hops-testing

For my future self
-------------------

This part of the guide is meant to be for those who will have to touch/maintain the testing infrastructure.

The HopsworksJenkins Github user has a fork of HopsWorks and each cookbook. All the interactions with GitHub done in the pipeline are done as this user using the git protocol and SSH key for authentication.
All the steps of the pipeline are run in the same node and the SSH key for the HopsworksJenkins user should be available on that node.

Currently all the VMs are run on the same Jenkins node (same machine, same user), this is achieved by giving the VMs different names (e.g. ubuntu and centos). To avoid both machines to be killed when one of the two finishes, we need to start the ``VBoxSVC`` process as daemon::

  /usr/lib/virtualbox/VBoxSVC --pidfile VBoxSVC.pid &

Both the HopsWorks build and the tests run are done inside the VM for several reasons. Building HopsWorks from outside the VM and copy the artifacts is really really really slow (Don't know why this happens. There were couple of issues on GitHub complaining about this.). Second reason are the Ruby and JS dependencies, it's a mess and I prefer doing the mess inside a VM and then destroy it than doing it on the physical machines and become crazy each time we have to update a dependency or change physical machine.
By doing it inside a VM is also easier to expand the set of configurations we test and requires minimal changes to the pipeline code (add new parallel stage and new template) and/or using multiple nodes for testing more configurations.

The workflow (pipeline) of a Jenkins build is define in the ``Jenkinsfile`` and is composed of the following steps:

1. Jenkins is notified by GitHub that there is a new PR to test
2. Jenkins runs a clean up, kills the VMs of the previous run and removes from all the repos the branch ``test_platform`` (both locally and from GitHub). The clean up is done at this stage, and not at the end of the previous testing iteration, to allow developers to look into the VMs for Karamel output in case of a failure in the deployment.
3. Jenkins updates all the local clones pulling from the master of the Hopshadoop organization
4. Jenkins creates for each repo a ``test_platform`` branch, merges the changes in the repos specified in the ``test_manifesto``, rewrites all the links in the Berksfiles to point to the forks of the Hopsworksjenkins user (``test_platform`` branches) and finally, it pushes everything on GitHub.
5. Jenkins starts the VMs using the Vagrantfiles inlcuded in the templates directory. The VMs have two shared folder: the .m2 directory, to cache maven artifacts across Jenkins builds and speed up the testing, and the test-report directory, to get the results of the test out of the VMs and make them available to Jenkins for publishing them.
6. Vagrant starts chef which as first step will clone ``hopsworksjenkins/hopsworks`` repo, compile it and put the artifacts in the `chef_file_cache` dir to be picked up during the deployments
7. Chef starts Karamel which will use ``hopsworksjenkins/hopsworks-chef`` to deploy everything
8. Chef runs tests.
9. Tests results are published
