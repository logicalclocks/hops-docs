Erasure Coding
==============

Configuration
-------------

The erasure coding API is flexibly configurable and hence comes with some new configuration options that are shown here. All configuration options can be set by creating an erasure-coding-site.xml in the Hops configuration folder. Note that Hops comes with reasonable default values for all of these values. However, erasure coding needs to be enabled manually.

.. code-block:: xml

	<property>
	  <name>dfs.erasure_coding.enabled</name>
	  <value>true</value>
	  <description>Enable erasure coding</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.codecs.json</name>
	  <value>
		[ 
		  {
			"id" : "xor",
			"parity_dir" : "/raid",
			"stripe_length" : 10,
			"parity_length" : 1,
			"priority" : 100,
			"erasure_code" : "io.hops.erasure_coding.XORCode",
			"description" : "XOR code"
		  },
		  {
			"id" : "rs",
			"parity_dir" : "/raidrs",
			"stripe_length" : 10,
			"parity_length" : 4,
			"priority" : 300,
			"erasure_code" : "io.hops.erasure_coding.ReedSolomonCode",
			"description" : "ReedSolomonCode code"
		  },
		  {
			"id" : "src",
			"parity_dir" : "/raidsrc",
			"stripe_length" : 10,
			"parity_length" : 6,
			"parity_length_src" : 2,
			"erasure_code" : "io.hops.erasure_coding.SimpleRegeneratingCode",
			"priority" : 200,
			"description" : "SimpleRegeneratingCode code"
		  },
		]
	  </value>
	  <description>Erasure coding codecs to be available to the API</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.parity_folder</name>
	  <value>/parity</value>
	  <description>The HDFS folder to store parity information in</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.recheck_interval</name>
	  <value>300000</value>
	  <description>How frequently should the system schedule encoding or repairs and check their state</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.repair_delay</name>
	  <value>1800000</value>
	  <description>How long should the system wait before scheduling a parity repair</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.parity_repair_delay</name>
	  <value>1800000</value>
	  <description>How long should the system wait before scheduling a parity repair</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.active_encoding_limit</name>
	  <value>10</value>
	  <description>Maximum number of active encoding jobs</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.active_repair_limit</name>
	  <value>10</value>
	  <description>Maximum number of active repair jobs</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.active_parity_repair_limit</name>
	  <value>10</value>
	  <description>Maximum number of active parity repair jobs</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.deletion_limit</name>
	  <value>100</value>
	  <description>Delete operations to be handle during one round</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.encoding_manager</name>
	  <value>io.hops.erasure_coding.MapReduceEncodingManager</value>
	  <description>Implementation of the EncodingManager to be used</description>
	</property>

	<property>
	  <name>dfs.erasure_coding.block_rapair_manager</name>
	  <value>io.hops.erasure_coding.MapReduceBlockRepairManager</value>
	  <description>Implementation of the repair manager to be used</description>
	</property>


