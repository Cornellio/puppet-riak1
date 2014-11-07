# @version $Id: $
#
class riak::service {

  service { 'iptables':
    ensure => 'stopped',
    enable => false,
    before => Service['riak'],
  }

  service { 'riak':
    ensure => 'running',
    enable => true,
  }

  if ($fqdn != $cluster_join_node) {

    exec { 'cluster-join':
      command => "riak-admin cluster join riak@${cluster_join_node}",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      before  => Exec['cluster-plan'],
      require => Service['riak'],
      unless  => "/usr/sbin/riak-admin member-status | grep ^valid.*${fqdn}",
    }

    exec { 'cluster-plan':
      command => 'riak-admin cluster plan',
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      before  => Exec['cluster-commit'],
      unless  => "/usr/sbin/riak-admin member-status | grep ^valid.*${fqdn}",
    }

    exec { 'cluster-commit':
      command => 'riak-admin cluster commit',
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless  => "/usr/sbin/riak-admin member-status | grep ^valid.*${fqdn}",
    }

  }

}