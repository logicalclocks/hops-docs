===================
Small Files Support
===================

HopsFS can store small files in the database with the file system metadata to increase the performance of small files. To enable this feature use the ```DB``` storage type for the folder that would store small files. For example,


.. code-block:: bash

    $ hdfs storagepolicies -setStoragePolicy -path <path> -policy DB

or using Java API

.. code-block:: java

      distributedFileSystem.setStoragePolicy(path, "DB");

When the storage policy for a folder is set to ```DB``` then all the small files (Default <= 64KB) will be stored in the database. Setting the storage policy for a parent folder is sufficient, that is, if no explicit storage policy is defined for descendant folders then the descendant folders will inherit the storage policy from its parent folders. The default size of small files can be changed using the following property in the ```hdfs-site.xml```


.. code-block:: xml

  <property>
    <name>dfs.db.file.max.size</name>
    <value>65536</value>
    <description>Largest file that can be stored in the database</description>
  </property>

**NOTE:** Changing this parameter requires restarting HopsFS Cluster and all the services that access the file system.


The small files are stored in `NDB disk data tables`_. The default tablespace and log file group names are ```ts_1``` and ```lg_1``` respectively. In the NDB configuration set the ```FileSystemPathDD``` parameter to store the disk data files on a high-performance NVMe SSD drive. The disk data files can also be set in the `NDB cluster definition`_ using *Chef*.


.. code-block:: yml

    attrs:
      ndb:
        ...
        nvme:
          disks:
            - '/dev/nvme0n1'
          format: true
          undofile_size: SIZE
          logfile_size:  SIZE 

Size of undo log file is set using ```undofile_size``` and the size of NDB disk data files is set using ```logfile_size```. 

.. _NDB disk data tables: https://dev.mysql.com/doc/refman/5.7/en/mysql-cluster-disk-data.html
.. _NDB cluster definition: https://github.com/logicalclocks/ndb-chef
