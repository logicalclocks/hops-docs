===========
HopsFS ACLs
===========

Hops Hadoop supports extended Access Control Lists (ACLs), in similar fashion to the feature introduced to Hadoop in version 2.4.0. Access Control Lists are a way of extending the standard unix file permissions, allowing users to extend file access based on additional group and user restrictions.

The implementation in HopsFS uses the same API as Hadoop, but with slightly changed semantics.

API
===

Below you can find a summary of the most important commands.

::

  hdfs dfs -getfacl /path         # get acl status
  hdfs dfs -setfacl -m user::rw-,user:hadoop:rw- /path #modify ACL
  hdfs dfs -setfacl -k /path      # remove default ACL
  hdfs dfs -setfacl -R …  /path   # apply recursively
  hdfs dfs -setfacl -x … /path    # remove specified entries
  hdfs dfs -setfacl --set … /path # fully replace acl 

Permission Order
================

In UNIX, HDFS and HopsFS, the file permission is checked in the following order:

::
  
  user > group > other

The permission check will exit on first match. That means that permissive entries further to the right will not give access to a user denied in a previous step, if the user or group has matched that of the user requesting access.

Adding ACLs causes the order to alter like so:

::

  user > named user > Union(group, named groups) > other

Worth noting is the meaning of 'Union' here. If the user's groups matches any in the third step, the checking will not proceed to the 'other' entry. Furthermore, if the user's group entries matches several in the Union step, an entry that provides access will overshadow an entry that denies access.

It is also important to note that the MASK entry of each file will limit permission in named user, group and named groups.

DEFAULT ACLs
============
Default ACLs are a mechanism for propagating access control entries down a subtree. Here lies the only, but important, distinction between the behavior or HopsFS and HDFS.

In short:

* HDFS: DEFALT ACL is inherited on child creation
* Hops: An inode with NO OWN ACL inherits the DEFAULT ACL from the nearest ancestor that has one

Modifying a default ACL of a directory, will automatically affect all children. However, the mask entry of each descendent inode will remain the same. Make sure to set the file creation group permission (file group permission is the mask in extended acls, the group permission itself becomes an extended entry) to be sufficiently permissive to allow DEFAULT ACLs to have an impact.

In HopsFS we only allow DEFAULT Named user, DEFAULT Named group, and DEFAULT group ACL.

References
==========
For additional information, see the official Hadoop Documentation: `HDFS ACL docs <https://hadoop.apache.org/docs/r2.4.1/hadoop-project-dist/hadoop-hdfs/HdfsPermissionsGuide.html#ACLs_Access_Control_Lists>`_.
