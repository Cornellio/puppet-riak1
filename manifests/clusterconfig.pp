# @version $Id: $
#
class riak::clusterconfig {

  File {
    ensure => 'present',
    owner => 'riak',
    group => 'riak',
    mode  => '0644',
    notify => Service['riak'],
  }

  file { "$conf_dir/$conf_api":
    content => template('riak/app.config.erb'),
  }

  file { "$conf_dir/$conf_vm":
    content => template('riak/vm.args.erb'),
  }

}
