# @version $Id: $
#
# == Class: riak
#
# Installs and configures a Riak cluster on RHEL distros
#
# - Installs Riak and Erlang
# - Ensures Riak daemon is running
# - Tunes Linux for performance, including:
#   - Sets kernel parameters and ulimits
#   - Changes I/O scheduler from CFQ to Deadline
# - Joins servers into cluster
#
# === Parameters
#
# [*cluster_join_node*]
#
#	The node to join when creating the cluster. This value should be
#   the same on all nodes that are to be in a cluster.
#
# [*sysctl_fs_file_max*]        default = "65536"
# [*ulimits_nofile_soft*]       default = "16000"
# [*ulimits_nofile_hard*]       default = "20000"

# System performance tuning set via kernel parameters and ulimits.

# [*ring_creation_size*]        default = "128"

# Ring creation size must be a multiple of 2. Use a large value such as
# 512 if you plan on scaling to large clusters.

# [*riak_api_pb_backlog*]       default = "64"
# [*riak_search*]               default = "false"
# [*riak_sysmon_process_limit*] default = "30"
# [*riak_control_enabled*]      default = "false"
# [*riak_control_username*]     default = "admin"
# [*riak_control_password*]     default = "pass"
#
# === Examples
#
#	To create a 5 node cluster and make all hosts join
#	 riak01-sc9.virginam.com:
#
# 	node /^riak0[1-5]\.virginam\.com$/ inherits basenode-linux {
# 		class {'riak': cluster_join_node => 'riak01.virginam.com', }
# 	}
#
# === Author
#
# Pete Cornell <https://github.com/Cornellio/puppet-riak>
#
class riak ($cluster_join_node) inherits riak::params {

  class {'riak::install':} ->
  class {'riak::baseconfig':} ->
  class {'riak::clusterconfig':} ->
  class {'riak::service':} ~>
  class {'riak::clusterjoin':}

}
