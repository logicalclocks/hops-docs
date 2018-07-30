====================
Platform Testing
====================

User Guide
----------------

Every pull request to Hopsworks or the cookbooks, needs to be tested before being merged into the master branch.
`hops-testing` performs end-to-end testing on the platform by executing the following steps:

* Spin up a set of new VMs with differing configuration setup (default Ubuntu/CentOS)
* Clone and build Hopsworks
* Deploy the platform
* Run the tests Hopsworks tests

A failure in building/deployment or testing will fail the entire Jenkins build.

Triggering the tests is trivial. Besides having a fork of the Hopsworks repo and of all the cookbook repos, developers need also have a fork of the ``hops-testing`` repo_.

Once developers are satisfied with their changes, they should open all the PRs necessary to merge their work to the upstream repository. In case of cookbook PRs, the links in the each Berksfile myst *always* point to master.

Developers must open also a new PR on the ``hops-testing`` repo. This last PR has to modify the ``test_manifesto`` file which contains the list of repos the change involves.

The format for this file should be::

    organization/reponame/branch
    organization/reponame/branch

Where *organization* is the developer's GitHub username, *reponame* is the repository name and *branch* is the branch which contains the changes.
The ``test_manifesto`` makes sure that all the PRs related to a single change are tested together.

The PR on the ``hops-testing`` repo will be picked up by Jenkins which then starts the testing process.

Please add a comment to each PR in the other repos with the link of the ``hops-testing`` PR, so it will be easier for maintainers to check your PRs and merge them.

.. _repo: https://github.com/hopshadoop/hops-testing

Developer Guide
-------------------

This part of the guide is meant to be for those who will have to touch/maintain the testing infrastructure.

The HopsworksJenkins Github user has a fork of Hopsworks and each cookbook. All the interactions with GitHub done in the pipeline are done as this user using the git protocol and SSH key for authentication.
All the steps of the pipeline are run in the same node and the SSH key for the HopsworksJenkins user should be available on that node.

Currently all the VMs are run on the same Jenkins node (same machine, same user), this is achieved by giving the VMs different names (e.g. ubuntu and centos). To avoid both machines to be killed when one of the two finishes, we need to start the ``VBoxSVC`` process as daemon::

  /usr/lib/virtualbox/VBoxSVC --pidfile VBoxSVC.pid &

Βuilding Hopsworks build and running tests run are both done inside the VM for several reasons.

1. Building Hopsworks outside the VM and copying the artifacts is slow.
2. Installing Ruby and JS dependencies can be messy and it is safer to do that in a VM environment than on the actual machine running the testing pipeline. 
3. It is to expand the set of configurations being tested and requires minimal changes to the pipeline code (add new parallel stage and new template) and/or using multiple nodes for testing various configurations.

The workflow (pipeline) of a Jenkins build is defined in the ``Jenkinsfile`` and is composed of the following steps:

1. Jenkins is notified by GitHub that there is a new PR to test.
2. Jenkins runs a clean up, kills the VMs of the previous run and removes from all the repos the branch ``test_platform`` (both locally and from GitHub). The clean up is done at this stage, and not at the end of the previous testing iteration, to allow developers to look into the VMs for Karamel output in case of a failure in the deployment.
3. Jenkins updates all the local clones pulling from the master of the Hopshadoop organization.
4. Jenkins creates for each repo a ``test_platform`` branch, merges the changes in the repos specified in the ``test_manifesto``, rewrites all the links in the Berksfiles to point to the forks of the Hopsworksjenkins user (``test_platform`` branches) and finally, it pushes everything to GitHub.
5. Jenkins starts the VMs using the Vagrantfiles inlcuded in the templates directory. The VMs have two shared folder: the .m2 directory, to cache maven artifacts across Jenkins builds and speed up the testing, and the test-report directory, to get the results of the test out of the VMs and make them available to Jenkins for publishing them.
6. Vagrant starts chef which as first step will clone ``hopsworksjenkins/hopsworks`` repo, compile it and put the artifacts in the `chef_file_cache` dir to be picked up during the deployments
7. Chef starts Karamel which will use ``hopsworksjenkins/hopsworks-chef`` to deploy everything
8. Chef runs tests.
9. Tests results are published.
