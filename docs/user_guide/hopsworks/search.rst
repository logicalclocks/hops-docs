Search
========================

You can search on the navigation bar for Datasets, Projects, Feature Groups, Features, and Training datasets.
The search bar behaves differently depending on whether you are on the landing page or inside a project. When you are on the landing page, as we can see from the below image, search can return any items that have not been marked explicitly as private when they were created. That is, unless you mark your Datasets, Features, Feature Groups, and Training Datasets private, they can be discovered (but not necessarily accessed) from the landing page.

.. figure:: ../../imgs/search/global_search.png
    :alt: Global Search
    :scale: 30%
    :figclass: align-center

In the case of searching on the landing page, as we can see in the image above, your search will target all items that have not been marked explicitly as being private when they were created. By default all the metadata of items (Projects, Datasets, Feature Groups, Features, Training Datasets) are public and searchable by all users in the cluster. The data however is always private and requires access granting by the owners in order to gain access to it. When searching globally you can narrow your search to the categories: Projects/Datasets/Featurestore (Featuregroup, Features and Training Datasets) by selecting the appropriate drop down option.

.. figure:: ../../imgs/search/project_search.png
    :alt: Project Search
    :scale: 30%
    :align: center
    :figclass: align-center

In the case of searching in the project dashboard, your search will target all items that this project has access to (access to their data) - this includes items that were created within this project as well as items that have been shared with this project. When searching within the project you can narrow your search to the categories: Datasets/Featurestore (Featuregroup, Features and Training Datasets).

.. figure:: ../../imgs/search/global_search_results.png
    :alt: Global Search Results
    :scale: 30%
    :figclass: align-center

Search results are divided in six tabs:

* Featuregroup

* Training dataset

* Feature 

* Projects

* Datasets

* Others (Directories and Files) 

Results will also have highlighted the reason why they matched your search query:

* Feature 
	* Name
* Feature Group
	* Name
	* Description
	* Tags
	* Features
* Training Dataset
	* Name
	* Description
	* Tags
	* Features
* Projects
    * Name
    * Description
* Datasets
    * Name
    * Description
    * Metadata
* Others (Directories and Files)
    * Name

.. figure:: ../../imgs/search/global_search_request.png
    :alt: Request access to data
    :scale: 30%
    :align: center
    :figclass: align-center

When you search from the landing page, if you discover an interesting item, you can click on the name or "Request access" menu in order to send a request to be granted access. When requesting access you need to provide a project that you want to save this shared item in. If the owner of the item accepts your request, you will now be able to access its contents from the project you selected.

.. figure:: ../../imgs/search/global_search_goto.png
    :alt: Go to location
    :scale: 30%
    :align: center
    :figclass: align-center

When searching globally if you have access to a particular item, you can see the link icon beside the name. In the case of shared items it can be the case that you can access this item from multiple projects, which is why you can select to which project you want to navigate to.
  
.. _search_by_feature_components:

Search By Feature Components
----------------------------
As can be seen in the previous section, Feature Groups and Training Datasets can be searched by their component features. This is based on HopsFS XAttr and thus the size of component features is going to be related to the maximum size configured for XAttrs. You can read more on how to configure XAttr size in :ref:`HopsFS XAttr Configuration <hopsfs_xattr_config>`.

For rough estimates of XAttr size related to number of features per
Feature Group/Training Dataset:

* XAttr size: 67755    - max  1000 features
* XAttr size: 634755   - max 10000 features
* XAttr size: 1039755  - max 16000 features
* XAttr size: 34427552 - max 54000 features

If the HopsFS XAttr max size is configured to a value smaller than required, the Features Groups/Training Datasets will not be searchable by Features. They will still be available and searchable by the other attributes. 

For example, if your HopsFS is configured to accept XAttr of maximum 634755 size, and you create a Feature Group with 15000 features, this Feature Group will not be searchable by its component feature names, but it will still be searchable by name.