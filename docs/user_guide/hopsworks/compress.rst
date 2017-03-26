===========================
Compress Files
===========================

HopFS supports erasure-coding of files, which reduces storage
requirements for large files by roughly 50%. If a file consists of 6
file blocks or more (that is, if the file is larger than 384 MB in
size, for a default block size of 64 MB), then it can be
compressed. Smaller files cannot be compressed.

.. tabularcolumns:: {|p{\dimexpr0.3\linewidth-2\tabcolsep}|p{\dimexpr 0.7\linewidth-2\tabcolsep}|}

+------------------+----------------------------------------+
| **Option**       | **Description**                        |
+==================+========================================+
| **compress**     | You have to have the **Data Owner**    |
| **file**         | role to be able to compress files.     |
|                  | Select a file from your project.       |
|                  | Right-click and select ``Compress``    |
|                  | to reduce the size of the file by      |
|                  | changing its replication policy from   |
|                  | triple replication to Reed-Solomon     |
|                  | erasure coding.                        |
+------------------+----------------------------------------+
