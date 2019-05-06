=============================
Extended Attributes in HopsFS
=============================

Overview
--------

*Extended attributes* (abbreviated as *xattrs*) is a filesystem feature that allows user applications to associate additional metadata with a file or directory. Unlike system-level inode metadata such as file permissions or modification time, extended attributes are not interpreted by the system and are instead used by applications to store additional information about an inode. Extended attributes could be used, for instance, to specify the character encoding of a plain-text document.

HopsFS extended attributes
~~~~~~~~~~~~~~~~~~~~~~~~~~
Extended attributes in HopsFS are modeled after extended attributes in Linux (see the Linux manpage for `attr(5) <http://www.bestbits.at/acl/man/man5/attr.txt>`_ and `related documentation <http://www.bestbits.at/acl/>`_. An extended attribute is a *name-value pair*, with a string name and binary value. Xattrs names must also be prefixed with a *namespace*. For example, an xattr named *myXattr* in the *user* namespace would be specified as **user.myXattr**. Multiple xattrs can be associated with a single inode.

Namespaces and Permissions
~~~~~~~~~~~~~~~~~~~~~~~~~~

In HopsFS, as in Linux, there are four valid namespaces: ``user``, ``trusted``, ``system``, and ``security``. Each of these namespaces have different access restrictions.

The ``user`` namespace will commonly be used by client applications. Access to extended attributes in the user namespace is controlled by the corresponding file permissions.

The ``trusted`` namespace is available only to HopsFS superusers.

The ``system`` namespace is reserved for internal HopsFS use. This namespace is not accessible through userspace methods, and is reserved for implementing internal HopsFS features.

The ``security`` namespace is reserved for internal HopsFS use. This namespace is not accessible through userspace methods. It is currently unused.

Interacting with extended attributes
------------------------------------

The Hadoop shell has support for interacting with extended attributes via `hadoop fs -getfattr` and `hadoop fs -setfattr`. These commands are styled after the Linux `getfattr(1) <http://www.bestbits.at/acl/man/man1/getfattr.txt>`_ and `setfattr(1) <http://www.bestbits.at/acl/man/man1/setfattr.txt>`_ commands.

getfattr
~~~~~~~~

``hadoop fs -getfattr [-R] -n name | -d [-e en] <path\>``

Displays the extended attribute names and values (if any) for a file or directory.

::

  | | |
  |:---- |:---- |
  | -R | Recursively list the attributes for all files and directories. |
  | -n name | Dump the named extended attribute value. |
  | -d | Dump all extended attribute values associated with pathname. |
  | -e \<encoding\> | Encode values after retrieving them. Valid encodings are "text", "hex", and "base64". Values encoded as text strings are enclosed in double quotes ("), and values encoded as hexadecimal and base64 are prefixed with 0x and 0s, respectively. |
  | \<path\> | The file or directory. |

setfattr
~~~~~~~~

``hadoop fs -setfattr -n name [-v value] | -x name <path\>``

Sets an extended attribute name and value for a file or directory.

::

  | | |
  |:---- |:---- |
  | -n name | The extended attribute name. |
  | -v value | The extended attribute value. There are three different encoding methods for the value. If the argument is enclosed in double quotes, then the value is the string inside the quotes. If the argument is prefixed with 0x or 0X, then it is taken as a hexadecimal number. If the argument begins with 0s or 0S, then it is taken as a base64 encoding. |
  | -x name | Remove the extended attribute. |
  | \<path\> | The file or directory. |


Configuration options
---------------------

HopsFS supports extended attributes out of the box, without additional configuration. Administrators might also be interested in the options limiting the number of xattrs per inode and the size of xattrs, since xattrs increase the on-disk and in-memory space consumption of an inode.

*   ``dfs.namenode.xattrs.enabled``

Whether support for extended attributes is enabled on the NameNode. By default, extended attributes are enabled.

*   ``dfs.namenode.fs-limits.max-xattrs-per-inode``

The maximum number of extended attributes per inode. By default, this limit is 32. The maximum allowed number is 255 extended attributes per inode.

*   ``dfs.namenode.fs-limits.max-xattr-size``

The maximum combined size of the name and value of an extended attribute in bytes. By default, the maximum allowed limit is 13985, where the name can take up to 255 bytes, and the value size can take up to 13730 bytes.

Compatibility with HDFS
-----------------------

HopsFS extended attributes are fully compatible with `HDFS 2.5 <https://hadoop.apache.org/docs/r2.5.2/hadoop-project-dist/hadoop-hdfs/ExtendedAttributes.html>`_. The main difference is the size limitations on the name and value of an extended attribute.
