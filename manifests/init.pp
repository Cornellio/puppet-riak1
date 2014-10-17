# @version $Id: $
#
# == Class: riak
#
# Installs and configures a Riak cluster on RHEL/CentOS
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
# [*cluster_root_node*]
#
#	Specifies the node to join when creating the cluster.  All
#	nodes that join the root node will become members of the same cluster. 
#
# === Variables
#
# Max file file handles are set via kernel parameters and ulimits:
#
# $sysctl_fs_file_max 
# $ulimits_nofile_soft
# $ulimits_nofile_hard
#
# Ring creation size must be a multiple of 2. Set to 512 to allow scaling
# to large clusters:
#
# $ring_creation_size
#
# === Examples
#
#	To create a 5 node cluster and define riak01-sc9.virginam.com as the
#	root node, add this node definition to nodes.pp:
#
# 	node /^riak0[1-5]-sc9\.virginam\.com$/ inherits basenode-linux {
# 		class {'riak': cluster_root_node => 'riak01-sc9.virginam.com', }
# 	}
#
# === Author
#
# Pete Cornell <pete.cornell@virginamerica.com>
#
class riak ($cluster_root_node) {

	class {'riak::install':} ->
	class {'riak::baseconfig':} ->
	class {'riak::clusterconfig':} ->
	class {'riak::service':}

}
