# @version $Id: $
#
class riak::baseconfig {

  # Disable requiretty via sudo to allow running init script

  exec { 'unset-sudo-requiretty':
    command => "/bin/sed -i 's/^Defaults.*requiretty/# Defaults requiretty/' /etc/sudoers",
    unless  => "/bin/grep -F '# Defaults requiretty' /etc/sudoers",
  }

  # System tuning

  mount { '/':
    ensure  => 'mounted',
    dump    => '1',
    fstype  => 'ext4',
    options => 'noatime,data=writeback,barrier=0',
    pass    => '1',
    target  => '/etc/fstab',
  }

  augeas { 'kernel-params':
    context => '/files/etc/sysctl.conf',
    changes => [
      "set fs.file-max[1] ${sysctl_fs_file_max}",
      'set vm.swappiness[1] 0',
      'set net.ipv4.tcp_max_syn_backlog[1] 40000',
      'set net.core.somaxconn[1] 4000',
      'set net.ipv4.tcp_timestamps[1] 0',
      'set net.ipv4.tcp_sack[1] 1',
      'set net.ipv4.tcp_window_scaling[1] 1',
      'set net.ipv4.tcp_fin_timeout[1] 15',
      'set net.ipv4.tcp_keepalive_intvl[1] 30',
      'set net.ipv4.tcp_tw_reuse[1] 1',
      'set net.core.rmem_default[1] 8388608',
      'set net.core.rmem_max[1] 8388608',
      'set net.core.wmem_default[1] 8388608',
      'set net.core.wmem_max[1] 8388608',
      'set net.core.netdev_max_backlog[1] 10000',
    ],
    before  => Exec['load-kernel-params'],
  }

  exec {'load-kernel-params':
    command => '/sbin/sysctl -e -p && /bin/touch /etc/sysctl.sentinel',
    unless  => '/usr/bin/stat /etc/sysctl.sentinel',
  }

  augeas { 'ulimit::nofiles':
    context   => '/files/etc/security/limits.conf',
      changes => [
        "set domain[1][. = '*'] *",
        "set domain[1][. = '*']/type soft",
        "set domain[1][. = '*']/item nofile",
        "set domain[1][. = '*']/value ${ulimits_nofile_soft}",
        "set domain[2][. = '*'] *",
        "set domain[2][. = '*']/type hard",
        "set domain[2][. = '*']/item nofile",
        "set domain[2][. = '*']/value ${ulimits_nofile_hard}",
      ],
   }

  exec { 'swap-disable':
     command     => '/sbin/swapoff -a',
     subscribe   => Package['riak'],
     refreshonly => true,
   }

  # Change IO scheduler from cfq to deadline

  if "grep -F '[cfq]' /sys/block/sda/queue/scheduler" {
    exec { 'set_ioscheduler_sda':
      command => '/bin/echo "deadline" > /sys/block/sda/queue/scheduler',
      returns => ['0', '1'],
      unless  => "/bin/grep -F '[deadline]' /sys/block/sda/queue/scheduler",
      onlyif  => '/usr/bin/stat /sys/block/sda',
    }
  }

  if "grep -F '[cfq]' /sys/block/sdb/queue/scheduler" {
    exec { 'set_ioscheduler_sdb':
      command => '/bin/echo "deadline" > /sys/block/sdb/queue/scheduler',
      returns => ['0', '1'],
      unless  => "/bin/grep -F '[deadline]' /sys/block/sdb/queue/scheduler",
      onlyif  => '/usr/bin/stat /sys/block/sdb',
    }
  }

  if "grep -F '[cfq]' /sys/block/sdc/queue/scheduler" {
    exec { 'set_ioscheduler_sdc':
      command => '/bin/echo "deadline" > /sys/block/sdc/queue/scheduler',
      returns => ['0', '1'],
      unless  => "/bin/grep -F '[deadline]' /sys/block/sdc/queue/scheduler",
      onlyif  => '/usr/bin/stat /sys/block/sdc',
    }
  }

}