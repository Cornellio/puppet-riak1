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

The module is designed with production systems in mind and aims to fully automate the deployment of a Riak cluster and tune your systems for optimal performance.

## Module Description

This module deploys a Riak cluster on Red Hat distributions. It's designed to automate the setup of an entire cluster and should be applied to multiple hosts. It will handle the operations necessary to create the cluster, including `plan`, `commit` and `join`. The module uses your existing yum repos to install Riak and Erlang and Linux will be tuned for performance as recommended by Basho.

The module has been tested on RHEL/CentOS 6.4 using riak-1.4.8 and erlang-rebar-2.1.0. Compatible with Puppet 2.7 or higher.

The class parameter `cluster_join_node` defines the host that all members of the cluster will join. All hosts that join this node will automatically be members of the same cluster.

## Setup

### Package Repositories

To avoid external dependencies this module is designed to use your existing yum repos, therefore ensure you have the following packages available:

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

    cluster_join_node
    required: yes

The node to join when creating the cluster.  All nodes that
you wish to make into a cluster should use the same value for this. The system you select is arbitrary and can be any host that will become part of the cluster.

#### Kernel Tuning Parameters

Set max file handles via sysctl and ulimits

    sysctl_fs_file_max
    default: 65536

    ulimits_nofile_soft
    default: 16000

    ulimits_nofile_hard
    default: 20000

#### Riak Parameters

    ring_creation_size
    default: 128

The number of partitions that make up your Riak cluster. Must be a multiple of 2. Check [cluster capacity planning](http://docs.basho.com/riak/1.3.1/references/appendices/Cluster-Capacity-Planning/#Ring-Size-Number-of-Partitions) docs for details.

    riak_api_pb_backlog
    default: 64

Maximum length to which the queue of pending connections may grow.

    riak_search
    default: false

To enable Search functionality set this 'true'. Not recommended on production systems.

    riak_sysmon_process_limit
    default: 30

Sysmon process limit.

    riak_control_enabled
    default: false

Whether to enable the Riak control GUI

    riak_control_username
    default: admin

Username for Riak control

    riak_control_password`
    default: pass

Password for Riak control

## Reference

* [Basho](http://basho.com)
* [Github](https://github.com/Cornellio/puppet-riak)
* [Puppet Forge](https://forge.puppetlabs.com/cornellio/riak)

## Limitations


If this node has not yet been provisioned when Puppet runs on other nodes, the cluster join operation will silently fail. The cluster join will succeed on future Puppet runs as long as the Riak daemon is running on the `cluster_join_node`.

Multiple Puppet runs may be necessary to bring all nodes into the cluster. If you ensure Riak has been provisioned on the host cited by `cluster_join_node` before the other nodes, everything should work after one Puppet run.

* If the system cited by `cluster_join_node` does not yet have Riak running when a host attempts to join the cluster, the cluster join operation will silently fail. When the system becomes available, subsequent runs will work.
* The Linux I/O scheduler is only tuned on the 3 first serial block devices detected. Needs to be generalized.
* Only tested on RHEL 6 distros so far

## Development

Visit the repo on [Github](https://github.com/Cornellio/puppet-riak)

## Contact

Pete Cornell / @9Dreamer / https://github.com/Cornellio / http://cornellio.net
