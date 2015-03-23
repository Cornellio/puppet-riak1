# @version $Id: $
#
class riak::params {

  $conf_dir                   = '/etc/riak'
  $conf_api                   = 'app.config'
  $conf_vm                    = 'vm.args'
  $sysctl_fs_file_max         = '65536'
  $ulimits_nofile_soft        = '16001'
  $ulimits_nofile_hard        = '20000'
  $ring_creation_size         = '128'
  $riak_api_pb_backlog        = '64'
  $riak_search                = false
  $riak_sysmon_process_limit  = '30'
  $riak_control_enabled       = false
  $riak_control_username      = 'admin'
  $riak_control_password      = 'pass'

}
