# @version $Id: $
#
class riak::clusterconfig {

  file { "/etc/riak/app.config":
    ensure    => "present",
    content   => template("riak/app.config.erb"),
    owner     => "riak",
    group     => "riak",
    mode      => "0644",
    notify => Service["riak"],
  }

  file { "/etc/riak/vm.args":
    ensure    => "present",
    content   => template("riak/vm.args.erb"),
    owner     => "riak",
    group     => "riak",
    mode      => "0644",
    notify => Service["riak"],
  }

}