# @version $Id: $
#
class riak::service {

  service { "iptables":
    enable => "false",
    ensure => "stopped",
    before => Service["riak"],
  }

  service { "riak":
    enable  => "true",
    ensure  => "running",
  }

  if ($fqdn != $cluster_root_node) {

    exec { "cluster-join":
      command => "riak-admin cluster join riak@$cluster_root_node",
      path    => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
      before  => Exec["cluster-plan"],
      require => Service["riak"],
      unless  => "/usr/sbin/riak-admin member-status | grep ^valid.*$fqdn",
    }

    exec { "cluster-plan":
      command => "riak-admin cluster plan",
      path    => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
      before  => Exec["cluster-commit"],
      unless  => "/usr/sbin/riak-admin member-status | grep ^valid.*$fqdn",
    }

    exec { "cluster-commit":
      command => "riak-admin cluster commit",
      path    => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
      unless  => "/usr/sbin/riak-admin member-status | grep ^valid.*$fqdn",
    }
  }

}
