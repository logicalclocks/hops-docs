Erasure Coding
==============

Configuration
-------------

The erasure coding API is flexibly configurable and hence comes with some new configuration options that are shown here. All configuration options can be set by creating an erasure-coding-site.xml in the Hops configuration folder. Note that Hops comes with reasonable default values for all of these values. However, erasure coding needs to be enabled manually.




* **dfs.erasure_coding.enabled**: (true/false) Enable/Disable erasure coding.

* **dfs.erasure_coding.codecs.json**: List of available erasure coding codecs available. This value is a json field i.e.

.. code-block:: xml

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


* **dfs.erasure_coding.parity_folder**: The HDFS folder to store parity information in. Default value is /parity

* **dfs.erasure_coding.recheck_interval**: How frequently should the system schedule encoding or repairs and check their state. Default valude is 300000 ms.

* **dfs.erasure_coding.repair_delay**: How long should the system wait before scheduling a repair. Default is 1800000 ms.

* **dfs.erasure_coding.parity_repair_delay**: How long should the system wait before scheduling a parity repair. Default is 1800000 ms. 

* **dfs.erasure_coding.active_encoding_limit**: Maximum number of active encoding jobs. Default is 10. 

* **dfs.erasure_coding.active_repair_limit**: Maximum number of active repair jobs. Default is 10. 

* **dfs.erasure_coding.active_parity_repair_limit**: Maximum number of active parity repair jobs. Default is 10. 

* **dfs.erasure_coding.deletion_limit**: Delete operations to be handle during one round. Default is 100.

* **dfs.erasure_coding.encoding_manager**: Implementation of the EncodingManager to be used. Default is ``io.hops.erasure_coding.MapReduceEncodingManager``.

* **dfs.erasure_coding.block_rapair_manager**: Implementation of the repair manager to be used. Default is ``io.hops.erasure_coding.MapReduceBlockRepairManager``


