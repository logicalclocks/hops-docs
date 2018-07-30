===========================
Leader Election
===========================

Leader election service is used by HopsFS and Hops-YARN. The configuration parameters for Leader Election service are defined in ``core-site.xml`` file.

* **dfs.leader.check.interval**:
  The length of the time period in milliseconds after which NameNodes run the leader election protocol. One of the active NameNodes is chosen as a leader to perform housekeeping operations. All NameNodes periodically update a counter in the database to mark that they are active. All NameNodes also periodically check for changes in the membership of the NameNodes. By default the time period is set to one second. Increasing the time interval leads to slow failure detection.
* **dfs.leader.missed.hb**:
  This property specifies when a NameNode is declared dead. By default a NameNode is declared dead if it misses two consecutive heartbeats. Higher values of this property would lead to slower failure detection. The minimum supported value is 2.
* **dfs.leader.tp.increment**:
    HopsFS uses an eventual leader election algorithm where the heartbeat time period (**dfs.leader.check.interval**) is automatically incremented if it detects that the NameNodes are falsely declared dead due to missed heartbeats caused by network/database/CPU overload. By default the heartbeat time period is incremented by 100 milliseconds, however it can be overridden using this parameter.
