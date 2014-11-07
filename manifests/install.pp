# @version $Id: $
#
class riak::install {
  
  package { 'riak':
    ensure => 'installed',
    before => File['/etc/riak/vm.args', '/etc/riak/app.config'],
  }
  
  package { 'erlang-rebar':
    ensure => 'installed',
    before => File['/etc/riak/vm.args', '/etc/riak/app.config'],
  }

}