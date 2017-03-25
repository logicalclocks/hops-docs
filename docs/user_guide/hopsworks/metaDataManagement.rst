===========================
Metadata Management
===========================

Metadata enables **data curation**, that is, ensuring that data is properly catalogued and accessible to appropriate users.

Metadata in HopsWorks is used primarily to discover and retrieve relevant data sets or files by users by enabling them to
attach arbitrary metadata to Data Sets, directories or files in HopsWorks. Metadata is associated with an individual file
or Data Set or directory. This extended metadata is stored in the same database as the metadata for HopsFS and foreign keys link
the extended metadata with the target file/directory/Data Set, ensuring its integrity.
Extended metadata is exported to Elastic Search, from where it can be queried and the associated Data Set/Project/file/directory
can be identified (and acted upon).
