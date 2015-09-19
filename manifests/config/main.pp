# Class: rsync::config::main
#
# rsync相关的主要配置文件管理
#
class rsync::config::main {

  File {
    mode    => 0644,
    group   => $::rsync::gid,
    owner   => $::rsync::uid,
  }

  file { $::rsync::conf_file:
    content => template("${module_name}/rsyncd.conf.erb")
  }

  if $::operatingsystem == 'Ubuntu' {
    file { '/etc/default/rsync':
      content => template("${module_name}/rsync_default.erb")
    }
  }

  if $::osfamily == 'RedHat' {
    file { '/etc/xinetd.d/rsync':
      content => template("${module_name}/xinetd_rsync.erb")
    }
  }
}
