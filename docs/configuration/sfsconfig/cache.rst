.. _cache-parameters:

===========================
NameNode Cache
===========================

The NameNode cache configuration parameters are defined in ``hdfs-site.xml`` file. The NameNode cache configuration parameters are:

* **dfs.resolvingcache.enabled**: (true/false)
  Enable/Disables the cache for the NameNode.

* **dfs.resolvingcache.type**: Each NameNode caches the inodes metadata in a local cache for quick path resolution. We support different implementations for the cache, i.e., INodeMemcache, PathMemcache, OptimalMemcache and InMemory.

    * **INodeMemcache**: stores individual inodes in Memcached.
    * **PathMemcache**: is a course grain cache where entire file path (key) along with its associated inodes objects are stored in the Memcached.
    * **OptimalMemcache**: combines INodeMemcache and PathMemcache.
    * **InMemory**: Same as INodeMemcache but instead of using Memcached it uses an inmemory **LRU ConcurrentLinkedHashMap**. We recommend **InMemory** cache as it yields higher throughput.

For INodeMemcache/PathMemcache/OptimalMemcache following configurations parameters must be set.

* **dfs.resolvingcache.memcached.server.address**:
  Memcached server address.

* **dfs.resolvingcache.memcached.connectionpool.size**:
  Number of connections to the memcached server.

* **dfs.resolvingcache.memcached.key.expiry**:
  It determines when the memcached entries expire. The default value is 0, that is, the entries never expire. Whenever the NameNode encounters an entry that is no longer valid, it updates it.


The InMemory cache specific configurations are:

* **dfs.resolvingcache.inmemory.maxsize**:
  Max number of entries that could be stored in the cache before the LRU algorithm kicks in.
