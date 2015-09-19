# Class: rsync::service
#
# 管理rsync服务状态
#
class rsync::service {

  if !($::rsync::service_ensure in ['running', 'stopped']){
    fail('service_ensure parameter must be running or stopped')
  }

  service { $::rsync::service_name:
    ensure     => $::rsync::service_ensure,
    enable     => $::rsync::service_enable,
    hasstatus  => true,
    hasrestart => true,
  }

}
