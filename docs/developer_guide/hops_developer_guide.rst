********************
Hops Developer Guide
********************


Extending HopsFS INode metadata 
-------------------------------

For the implementation of new features, it is often necessary to modify INode in order to store additional metadata. With Hops-HDFS, this can be simply achieved by adding a new table with a foreign reference to INode. Thus, the original data structure does not need to be modified and old code paths not requiring the additional metadata are not burdened with additional reading costs. This guide gives a walkthrough on how to add additional INode-related metadata.

Example use case
~~~~~~~~~~~~~~~~

Let's assume we would like to store per user access times for each INode. To do this, we need to store the id of the inode, the name of the user and the timestamp representing the most recent access.

Adding a table to the schema
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

First, we need to add a new table storing the metadata to our schema. Therefor we'll go to the *hops-metadata-dal-impl-ndb* project and add the following to the *schema/schema.sql* file.

.. code-block:: sql
		
	CREATE TABLE `hdfs_access_time_log` (
		`inode_id` int(11) NOT NULL,
		`user` varchar(32) NOT NULL,
		`access_time` bigint(20) NOT NULL,
		PRIMARY KEY (`inode_id` , `user`)
	) ENGINE=ndbcluster DEFAULT CHARSET=latin1$$


Additionally we will make the table and column names available to the Java code by adding the following to the *io.hops.metadata.hdfs.TablesDef* class in *hops-metadata-dal*.

.. code-block:: java

	public static interface AccessTimeLogTableDef {
		public static final String TABLE_NAME = "hdfs_access_time_log";
		public static final String INODE_ID = "inode_id";
		public static final String USER = "user";
		public static final String ACCESS_TIME = "access_time";
	}


:Note: `Don't forget to update your database with the new schema.`

Defining the entity class
~~~~~~~~~~~~~~~~~~~~~~~~~

Having defined the database table, we will need to defining an entity class representing our database entries in the java code. We will do this by adding the following AccessTimeLogEntry class *hops-metadata-dal* project.

.. code-block:: java

    package io.hops.metadata.hdfs.entity;
    
    public class AccessTimeLogEntry {
      private final int inodeId;
      private final String user;
      private final long accessTime;
    
      public AccessTimeLogEntry(int inodeId, String user
        , long accessTime) {
        this.inodeId = inodeId;
        this.user = user;
        this.accessTime = accessTime;
      }
    
      public int getInodeId() {
        return inodeId;
      }
    
      public String getUser() {
        return user;
      }
    
      public long getAccessTime() {
        return accessTime;
      }
    }

Defining the DataAccess interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We will need a way for interacting with our new entity in the database. The preferred way of doing this in Hops is defining a DataAccess interface to be implemented by a database implementation. Let's define define the following interface in the *hops-metadata-dal* project. For now, we will only require functionality to add and modify log entries and to read individual entries for a given INode and user.


.. code-block:: java

    package io.hops.metadata.hdfs.dal;
    
    public interface AccessTimeLogDataAccess<T> extends EntityDataAccess {
    
      void prepare(Collection<T> modified, 
        Collection<T> removed) throws StorageException;
      T find(int inodeId, String user) throws StorageException;
    }


Implementing the DataAccess interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Having defined the interface, we will need to implement it using ndb to read and persist our data. Therefor, we will add a clusterj implementation of our interface to the *hops-metadata-dal-impl-ndb* project.

.. code-block:: java
		
    package io.hops.metadata.ndb.dalimpl.hdfs;
    
    public class AccessTimeLogClusterj implements TablesDef.AccessTimeLogTableDef,
        AccessTimeLogDataAccess<AccessTimeLogEntry> {
    
      private ClusterjConnector connector = ClusterjConnector.getInstance();
    
      @PersistenceCapable(table = TABLE_NAME)
      public interface AccessTimeLogEntryDto {
        @PrimaryKey
        @Column(name = INODE_ID)
        int getInodeId();
    
        void setInodeId(int inodeId);
    
        @PrimaryKey
        @Column(name = USER)
        String getUser();
    
        void setUser(String user);
    
        @Column(name = ACCESS_TIME)
        long getAccessTime();
    
        void setAccessTime(long accessTime);
      }
    
      @Override
      public void prepare(Collection<AccessTimeLogEntry> modified,
          Collection<AccessTimeLogEntry> removed) throws StorageException {
        HopsSession session = connector.obtainSession();
        List<AccessTimeLogEntryDto> changes =
                        new ArrayList<accesstimelogentrydto>();
        List<AccessTimeLogEntryDto> deletions = 
                        new ArrayList<accesstimelogentrydto>();
        if (removed != null) {
          for (AccessTimeLogEntry logEntry : removed) {
            Object[] pk = new Object[2];
            pk[0] = logEntry.getInodeId();
            pk[1] = logEntry.getUser();
            InodeDTO persistable = 
                  session.newInstance(AccessTimeLogEntryDto.class, pk);
            deletions.add(persistable);
          }
        }
        if (modified != null) {
          for (AccessTimeLogEntry logEntry : modified) {
            AccessTimeLogEntryDto persistable = 
                  createPersistable(logEntry, session);
            changes.add(persistable);
          }
        }
        session.deletePersistentAll(deletions);
        session.savePersistentAll(changes);
      }
    
      @Override
      public AccessTimeLogEntry find(int inodeId, String user) 
          throws StorageException {
        HopsSession session = connector.obtainSession();
        Object[] key = new Object[2];
        key[0] = inodeId;
        key[1] = user;
        AccessTimeLogEntryDto dto = session.find(AccessTimeLogEntryDto.class, key);
        AccessTimeLogEntry logEntry = create(dto);
        return logEntry;
      }
    
      private AccessTimeLogEntryDto createPersistable(AccessTimeLogEntry logEntry, 
          HopsSession session) throws StorageException {
        AccessTimeLogEntryDto dto = session.newInstance(AccessTimeLogEntryDto.class);
        dto.setInodeId(logEntry.getInodeId());
        dto.setUser(logEntry.getUser());
        dto.setAccessTime(logEntry.getAccessTime());
        return dto;
      }
    
      private AccessTimeLogEntry create(AccessTimeLogEntryDto dto) {
        AccessTimeLogEntry logEntry = new AccessTimeLogEntry(
          dto.getInodeId(), 
          dto.getUser(), 
          dto.getAccessTime());
        return logEntry;
      }
    }

  

Having defined a concrete implementation of the DataAccess, we need to make it available to the ``EntityManager`` by adding it to ``HdfsStorageFactory`` in the ``hops-metadata-dal-impl-ndb`` project. Edit its ``initDataAccessMap()`` function by adding the newly defined DataAccess as following.

.. code-block:: java
		
    private void initDataAccessMap() {
      [...]
      dataAccessMap.put(AccessTimeLogDataAccess.class, new AccessTimeLogClusterj());
    }


Implementing the EntityContext
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Hops-HDFS uses context objects to cache the state of entities during transactions before persisting them in the database during the commit phase. We will need to implement such a context for our new entity in the *hops* project.


.. code-block:: java
		
    package io.hops.transaction.context;
    
    public class AccessTimeLogContext extends 
              BaseEntityContext<Object, AccessTimeLogEntry> {
      private final AccessTimeLogDataAccess<AccessTimeLogEntry> dataAccess;
    
      /* Finder to be passed to the EntityManager */
      public enum Finder implements FinderType<AccessTimeLogEntry> {
        ByInodeIdAndUser;
    
        @Override
        public Class getType() {
          return AccessTimeLogEntry.class;
        }
    
        @Override
        public Annotation getAnnotated() {
          switch (this) {
            case ByInodeIdAndUser:
              return Annotation.PrimaryKey;
            default:
              throw new IllegalStateException();
          }
        }
      }
    
      /* 
       * Our entity uses inode id and user as a composite key.
       * Hence, we need to implement a composite key class.
       */
      private class Key {
        int inodeId;
        String user;
    
        public Key(int inodeId, String user) {
          this.inodeId = inodeId;
          this.user = user;
        }
    
        @Override
        public boolean equals(Object o) {
          if (this == o) {
            return true;
          }
          if (o == null || getClass() != o.getClass()) {
            return false;
          }
    
          Key key = (Key) o;
    
          if (inodeId != key.inodeId) {
            return false;
          }
          return user.equals(key.user);
        }
    
        @Override
        public int hashCode() {
          int result = inodeId;
          result = 31 * result + user.hashCode();
          return result;
        }
    
        @Override
        public String toString() {
          return "Key{" +
              "inodeId=" + inodeId +
              ", user='" + user + '\'' +
            '}';
        }
      }
    
      public AccessTimeLogContext(AccessTimeLogDataAccess<AccessTimeLogEntry> 
        dataAccess) {
        this.dataAccess = dataAccess;
      }
    
      @Override
      Object getKey(AccessTimeLogEntry logEntry) {
        return new Key(logEntry.getInodeId(), logEntry.getUser());
      }
    
      @Override
      public void prepare(TransactionLocks tlm)
          throws TransactionContextException, StorageException {
        Collection<AccessTimeLogEntry> modified =
            new ArrayList<AccessTimeLogEntry>(getModified());
        modified.addAll(getAdded());
        dataAccess.prepare(modified, getRemoved());
      }
    
      @Override
      public AccessTimeLogEntry find(FinderType<AccessTimeLogEntry> finder,
          Object... params) throws TransactionContextException, 
          StorageException {
        Finder afinder = (Finder) finder;
        switch (afinder) {
          case ByInodeIdAndUser:
            return findByPrimaryKey(afinder, params);
        }
        throw new UnsupportedOperationException(UNSUPPORTED_FINDER);
      }
    
      private AccessTimeLogEntry findByPrimaryKey(Finder finder, Object[] params)
          throws StorageCallPreventedException, StorageException {
        final int inodeId = (Integer) params[0];
        final String user = (String) params[1];
        Key key = new Key(inodeId, user);
        AccessTimeLogEntry result;
        if (contains(key)) {
          result = get(key);  // Get it from the cache
          hit(finder, result, params);
        } else {
          aboutToAccessStorage(finder, params); // Throw an exception 
                                 //if reading after the reading phase
          result = dataAccess.find(inodeId, user); // Fetch the value
          gotFromDB(key, result); // Put the new value into the cache
          miss(finder, result, params);
        }
        return result;
      }
    }


Having defined an ``EntityContext``, we need to make it available through the EntityManger by adding it to the ``HdfsStorageFactory`` in the ``hops`` project by modifying it as follows.

.. code-block:: java
		
    private static ContextInitializer getContextInitializer() {
      return new ContextInitializer() {
        @Override
        public Map<Class, EntityContext> createEntityContexts() {
          Map<Class, EntityContext> entityContexts = 
                            new HashMap<class, entitycontext="">();
          [...]
          
          entityContexts.put(AccessTimeLogEntry.class, new AccessTimeLogContext(
            (AccessLogDataAccess) getDataAccess(AccessTimeLogDataAccess.class)));
          return entityContexts;
        }  
      }
    }


Using custom locks
~~~~~~~~~~~~~~~~~~

YOur metadata extension relies on the inode object to be correctly locked in order to prevent concurrent modifications. However, it might be necessary to modify attributes without locking the INode in advance. In that case, one needs to add a new lock type. A good place to get started with this is looking at the ``Lock``, ``HdfsTransactionLocks``, ``LockFactory`` and ``HdfsTransactionalLockAcquirer`` classes in the ``hops`` project.


Erasure Coding
--------------


HopsFS provides erasure coding functionality in order to decrease storage costs without the loss of high-availability. Hops offers a powerful, on a per file basis configurable, erasure coding API. Codes can be freely configured and different configurations can be applied to different files. Given that Hops monitors your erasure-coded files directly in the NameNode, maximum control over encoded files is guaranteed. This page explains how to configure and use the erasure coding functionality of Hops. Apache HDFS stores 3 copies of your data to provide high-availability. So, 1 petabyte of data actually requires 3 petabytes of storage. For many organizations, this results in enormous storage costs. HopsFS also supports erasure coding to reduce the storage required by by 44% compared to HDFS, while still providing high-availability for your data.


Java API
~~~~~~~~

The erasure coding API is exposed to the client through the DistributedFileSystem class. The following sections give examples on how to use its functionality. Note that the following examples rely on erasure coding being properly configured. Information about how to do this can be found in :ref:`erasure-coding-configuration`.


Creation of Encoded Files
~~~~~~~~~~~~~~~~~~~~~~~~~

The erasure coding API offers the ability to request the encoding of a file while being created. Doing so has the benefit that file blocks can initially be placed in a way that the meets placements constraints for erasure-coded files without needing to rewrite them during the encoding process. The actual encoding process will take place asynchronously on the cluster.

.. code-block:: java

	Configuration conf = new Configuration();
	DistributedFileSystem dfs = (DistributedFileSystem) FileSystem.get(conf);
	// Use the configured "src" codec and reduce 
	// the replication to 1 after successful encoding
	EncodingPolicy policy = new EncodingPolicy("src" /* Codec id as configured */,
	                        (short) 1);
	// Create the file with the given policy and 
	// write it with an initial replication of 2
	FSDataOutputStream out = dfs.create(path, (short) 2,  policy);
	// Write some data to the stream and close it as usual
	out.close();
	// Done. The encoding will be executed asynchronously 
	// as soon as resources are available.


Multiple versions of the create function complementing the original versions with erasure coding functionality exist. For more information please refer to the class documentation.

Encoding of Existing Files
~~~~~~~~~~~~~~~~~~~~~~~~~~

The erasure coding API offers the ability to request the encoding for existing files. A replication factor to be applied after successfully encoding the file can be supplied as well as the desired codec. The actual encoding process will take place asynchronously on the cluster.

.. code-block:: java

	Configuration conf = new Configuration();
	DistributedFileSystem dfs = (DistributedFileSystem) FileSystem.get(conf);
	String path = "/testFile";
	// Use the configured "src" codec and reduce the replication to 1
	// after successful encoding
	EncodingPolicy policy = new EncodingPolicy("src" /* Codec id as configured */,
	                                 (short) 1);
	// Request the asynchronous encoding of the file
	dfs.encodeFile(path, policy);
	// Done. The encoding will be executed asynchronously 
	// as soon as resources are available.


Reverting To Replication Only
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The erasure coding API allows to revert the encoding and to default to replication only. A replication factor can be supplied and is guaranteed to be reached before deleting any parity information.

.. code-block:: java

	Configuration conf = new Configuration();
	DistributedFileSystem dfs = (DistributedFileSystem) FileSystem.get(conf);
	// The path to an encoded file
	String path = "/testFile";
	// Request the asynchronous revocation process and 
	// set the replication factor to be applied
	 dfs.revokeEncoding(path, (short) 2);
	// Done. The file will be replicated asynchronously and 
	// its parity will be deleted subsequently.


Deletion Of Encoded Files
~~~~~~~~~~~~~~~~~~~~~~~~~

Deletion of encoded files does not require any special care. The system will automatically take care of deletion of any additionally stored information.


.. _Apache Hadoop: http://hadoop.apache.org/releases.html
.. _Hadoop configuration parameters: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml
.. _service: http://link.springer.com/chapter/10.1007%2F978-3-319-19129-4_13

