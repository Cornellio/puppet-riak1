# @version $Id: $
#
class riak::params {

  $conf_dir             = "/etc/riak"
  $conf_api             = "app.config"
  $conf_vm              = "vm.args"  
  $sysctl_fs_file_max   = "65536"
  $ulimits_nofile_soft  = "16000"
  $ulimits_nofile_hard  = "20000"
  $ring_creation_size   = "128"

}