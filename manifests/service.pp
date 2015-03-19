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

}