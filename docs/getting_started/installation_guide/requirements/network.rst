==========================
Network Requirements
==========================

Hosts must satisfy the following networking and security requirements:

* IPv4 should be enabled, and, for Enterprise installations with Kubernetes, IPv6 must also be enabled.
* Cluster hosts must be able to resolve hostnames using either the /etc/hosts file or forward and reverse host resolution through DNS. The /etc/hosts files must be the same on all hosts, containing both hostnames and IP addresses. Hostnames should not contain uppercase letters and IP addresses must be unique. Hosts must not use aliases either in DNS or in the /etc/hosts files. 
* The installer must have SSH and sudo access to the hosts where you are installing Hopsworks' services.
* Disable or configure firewalls (e.g., iptables or firewalld) to allow access to ports used by Hopsworks' services.
* The hostname returned by the 'hostname' command in  RHEL and CentOS must be correct. (You can also find the hostname in /etc/sysconfig/network).
