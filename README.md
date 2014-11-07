# Riak

<!--toc-->

## Overview

Riak is a high performance, distributed key/value data store.

This module installs and configures a Riak cluster on RHEL distros. Riak and Erlang packages are installed via RPM from your existing yum repos. Linux performance tuning is performed as recommended by Basho and the module will authomatically join your nodes into a cluster. 

The module has been tested on RHEL/CentOS 6.4 using riak-1.4.8 and erlang-rebar-2.1.0. Compatibile with Puppet 2.7 or higher.

The Riak packages need to be available in your existing yum repos.

## Module Description

The class parameter `cluster_join_node` defines the host that all members of the cluster will join. All hosts that join this node will automatically be members of the same cluster. If this node has not yet been provisioned when Puppet runs on other nodes, the cluster join operation will silently fail. The cluster join will succeed on the next Puppet run as long as the Riak daemon is running on the `cluster_join_node`.

Multipe Puppet runs may be necessary to bring all nodes into the cluster. If you ensure Riak has been provisioned on the root node before the other nodes, everything should work after one Puppet run.

## Setup

Ensure the following packages are available in your configured yum repos.

* riak-1.4.8
* erlang-rebar-2.1.0

### What Riak affects

These packages will be Installed:

* riak-1.4.8
* erlang-rebar-2.1.0

Performance optimizations are made as recommended by Basho:

* Sets Linux kernel parameters and tunes ulimits as required
* Swap disk is disabled
* Filesystem mount options are added to improve I/O
* The Linux I/O scheduler (elevator) is changed from CFQ to Deadline for the 3 first serial block devices detected, e.g. /dev/sda, /dev/sdb and /dev/sdc. 
  
## Usage

To create a 5 node cluster and define riak01.domain.local as the
root node, you could use this node definition:

    node /^riak0[1-5]\.domain\.local$/  {
      class { 'riak': cluster_join_node => 'riak01.domain.local', }
    }

### Parameters

    cluster_join_node`

The node to join when creating the cluster.  All nodes that
you wish to make into a cluster should use the same value for this.

    sysctl_fs_file_max - default = 65536
    ulimits_nofile_soft - default = 16000
    ulimits_nofile_hard - default = 20000

System performance tuning is set via kernel parameters and ulimits, essentially by increasing max file handles.

    ring_creation_size - default = 128

The number of partitions that make up your Riak cluster is set by `ring_creation_size`. The ring size you choose will be the same for the life of the cluster, so taking growth into consideration is important. This value must must be a multiple of 2. A small value such as 64 would be suitable for up to 5 nodes, but a larger value such as 512 should be used if you plan on scaling beyond 5 nodes. See the [cluster capacity planning](http://docs.basho.com/riak/1.3.1/references/appendices/Cluster-Capacity-Planning/#Ring-Size-Number-of-Partitions) docs for details.

## Reference

* [Basho](http://basho.com)
* [Github](https://github.com/Cornellio/puppet-riak)

## Limitations

So far the module has only been used on RHEL/CentOS 6.4 using Puppet 2.7.

Multipe Puppet runs may be necessary to bring all nodes into the cluster as described above. Linux I/O scheduler is only adjusted for the 3 first serial block devices detected and needs to be more generalized.

## Development

[Visit the repo on Github](https://github.com/Cornellio/puppet-riak)

## Contributors

Pete Cornell