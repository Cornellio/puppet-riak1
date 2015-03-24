# Riak

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
7. [Contributors](#contributors)

## Overview

Riak is a high performance, distributed key/value data store released by [Basho.](http://basho.com/riak/)

This module deploys a Riak cluster on Red Hat distributions. Since it's designed to automate the setup of an entire cluster it can be applied to multiple hosts and will handle the operations necessary to create the cluster, including `plan`, `commit` and `join`. The module uses your existing yum repos to install Riak and Erlang and Linux will be tuned for performance as recommended by Basho.

The module has been tested on RHEL/CentOS 6.4 using riak-1.4.8 and erlang-rebar-2.1.0. Compatible with Puppet 2.7 or higher.

The Riak packages need to be available in your existing yum repos.

## Module Description

The class parameter `cluster_join_node` defines the host that all members of the cluster will join. All hosts that join this node will automatically be members of the same cluster. If this node has not yet been provisioned when Puppet runs on other nodes, the cluster join operation will silently fail. The cluster join will succeed on the next Puppet run as long as the Riak daemon is running on the `cluster_join_node`.

Multiple Puppet runs may be necessary to bring all nodes into the cluster. If you ensure Riak has been provisioned on the host cited by `cluster_join_node` before the other nodes, everything should work after one Puppet run.

## Setup

### Package Repositories

As to avoid external dependencies, this module is designed to use internal yum repos, therefore ensure the following packages are available in your configured yum repos.

* riak-1.4.8
* erlang-rebar-2.1.0

### Name Resolution

Working name resolution is required. Ensure that each host can resolve itself and the host that's specified by the `cluster_join_node` parameter.

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

To create a 5 node cluster with a ring size of 256 where all nodes join `riak01.domain.local`:

While not strictly necessary, you may want to provision Riak on `riak01.domain.local` before the other nodes so it will be ready to accept members as they join the cluster.

Create a node definition like so:

    node /^riak0[1-5]\.domain\.local$/  {
        class { 'riak':
            cluster_join_node  => 'riak01.domain.local',
            ring_creation_size => '256',
        }
    }

### Parameters

#### `cluster_join_node`

The node to join when creating the cluster.  All nodes that
you wish to make into a cluster should use the same value for this. The system you select is arbitrary and can be any host that will become part of the cluster.

#### Kernel Tuning Parameters

Increasing max file handles via sysctl and ulimits

`sysctl_fs_file_max`
default: 65536

`ulimits_nofile_soft`
default: 16000

`ulimits_nofile_hard`
default: 20000

#### `ring_creation_size`

The number of partitions that make up your Riak cluster. Must be a multipel of 2. Check [cluster capacity planning](http://docs.basho.com/riak/1.3.1/references/appendices/Cluster-Capacity-Planning/#Ring-Size-Number-of-Partitions) docs for details.
default: 128

#### `riak_api_pb_backlog`
Maximum length to which the queue of pending connections may grow.
default: 64

#### `riak_search`
To enable Search functionality set this 'true'. Not recommended on production systems.
default: false

#### `riak_sysmon_process_limit`
Sysmon process limit.
default: 30

#### `riak_control_enabled`
Whether to enable the Riak control GUI
default: false

#### `riak_control_username`
Username for Riak control
default: admin

#### `riak_control_password`
Password for Riak control
default: pass

## Reference

* [Basho](http://basho.com)
* [Github](https://github.com/Cornellio/puppet-riak)

## Limitations

* Only supported on RHEL 6 distros
* If the system cited by `cluster_join_node` does not yet have Riak running when a host attempts to join the cluster, the cluster join operation will silently fail.
* The Linux I/O scheduler is only tuned on the 3 first serial block devices detected; needs to be more generalized

## Development

Visit the repo on [Github](https://github.com/Cornellio/puppet-riak)

## Contact

Pete Cornell / @9Dreamer / https://github.com/Cornellio
