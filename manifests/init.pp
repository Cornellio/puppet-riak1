# @version $Id: $
#
# == Class: riak
#
# Installs and configures a Riak cluster on RHEL distros
#
# - Installs Riak and Erlang
# - Ensures Riak daemon is running
# - Tunes Linux for Riak, including:
#   - Sets kernel parameters and ulimits
#   - Changes I/O scheduler from CFQ to Deadline
# - Joins servers into cluster
#
# === Parameters
#
# [*cluster_join_node*]
#
#	The node to join when creating the cluster.  All nodes that
#	you wish to make into a cluster should use the same value for this.
#
# [*sysctl_fs_file_max*] - default = 65536
# [*ulimits_nofile_soft*] - default = 16000
# [*ulimits_nofile_hard*] - default = 20000
#
# System performance tuning is set via kernel parameters and ulimits.
#
# [*ring_creation_size*] - default = 128
#
# Ring creation size must be a multiple of 2. Use a large value such as
# 512 if you plan on scaling to large clusters.
#
# === Examples
#
#	To create a 5 node cluster and define riak01-sc9.virginam.com as the
#	root node, add this node definition to nodes.pp:
#
# 	node /^riak0[1-5]\.virginam\.com$/ inherits basenode-linux {
# 		class {'riak': cluster_join_node => 'riak01.virginam.com', }
# 	}
#
# === Author
#
# Pete Cornell <https://github.com/Cornellio/puppet-riak>
#
class riak (

  $cluster_join_node,
  $sysctl_fs_file_max  = $riak::params::sysctl_fs_file_max,
  $ulimits_nofile_soft = $riak::params::ulimits_nofile_soft,
  $ulimits_nofile_hard = $riak::params::ulimits_nofile_hard,
  $ring_creation_size  = $riak::params::ring_creation_size

) inherits riak::params {

  class {'riak::install':} ->
  class {'riak::baseconfig':} ->
  class {'riak::clusterconfig':} ->
  class {'riak::service':} ~>
  class {'riak::clusterjoin':}

}
