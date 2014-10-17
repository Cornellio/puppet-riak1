#Riak

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What Riak affects](#What-Riak-affects)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
7. [Contributors](#Contributors)

##Overview

Riak is an open source, distributed key/value database.

This module Installs and configures a Riak cluster on RHEL and rebuild distributions. Riak and Erlang packages are installed via RPM from your existing yum repos. Linux performance tuning is performed as recommended by Basho and the module will authomatically join your nodes into a cluster. 

Tested on RHEL/CentOS 6.4 with riak-1.4.8 and erlang-rebar-2.1.0 and Puppet 2.7 or higher.

##Module Description

The class parameter `cluster_root_node` defines the host that all members of the cluster will join. All hosts that join this node will automatically be members of the same cluster. If this node has not yet been provisioned when Puppet runs on other nodes, the cluster join operation will silently fail. The cluster join will succeed on the next Puppet run as long as the Riak daemon is running on the cluster_root_node.

Multipe Puppet runs may be necessary to bring all nodes into the cluster. If you ensure Riak has been provisioned on the root node before the other nodes, everything should work after one Puppet run

##Setup

Ensure your yum repos are working and that riak-1.4 and erlang-rebar-2 are available. 

  yum info riak
  yum info erlang-rebar

###What Riak affects

These packages will be Installed:

* riak-1.4.8
* erlang-rebar-2.1.0

These performance optimizations are made as recommended by Basho:

* Sets Linux kernel parameters and tunes ulimits as required
* Swap disk is disabled
* Filesystem mount options are added to improve I/O
* The Linux I/O scheduler (elevator) is changed from CFQ to Deadline for the 3 first serial block devices detected, e.g. /dev/sda, /dev/sdb and /dev/sdc. 
  
##Usage

To create a 5 node cluster and define riak01.domain.local as the
root node, you could use this node definition.

  node /^riak0[1-5]\.domain.local/  {
    class { 'riak': cluster_root_node => 'riak01.domain.local', }
  }

### Parameters

[*cluster_root_node*]
 
Specifies the node to join when creating the cluster.  All
nodes that join the root node will become members of the same cluster. 

### Variables

In `baseconfig.pp:` 

Max file file handles are set via kernel parameters and ulimits. Ring creation size must be a multiple of 2. Set to 512 to allow scaling
to large clusters.
 
  $sysctl_fs_file_max 
  $ulimits_nofile_soft
  $ulimits_nofile_hard
  $ring_creation_size

##Reference

http://basho.com
https://github.com/Cornellio/puppet-riak

##Limitations

So far the module has only been used on RHEL/CentOS 6.4 using Puppet 2.7.

Multipe Puppet runs may be necessary to bring all nodes into the cluster as described above. Linux I/O scheduler is only adjusted for the 3 first serial block devices detected and needs to be more generalized.

##Development

[Visit the repo on Github](https://github.com/Cornellio/puppet-riak)

##Contributors

Pete Cornell