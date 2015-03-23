# @version $Id: $
#
class riak::clusterjoin {

  if ($::fqdn != $::cluster_join_node) {

    exec { 'cluster-join':
      command     => "riak-admin cluster join riak@${riak::cluster_join_node}",
      path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      before      => Exec['cluster-plan'],
      require     => Service['riak'],
      refreshonly => true,
    }

    exec { 'cluster-plan':
      command     => 'riak-admin cluster plan',
      path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      before      => Exec['cluster-commit'],
      refreshonly => true,
    }

    exec { 'cluster-commit':
      command     => 'riak-admin cluster commit',
      path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      refreshonly => true,
    }

  }

}
