# Class: rsync::params
#
# 参数类
#
class rsync::params {
  case $::operatingsystem{
    'Ubuntu' : {
      $pkg_names    = ['rsync']
      $conf_file    = '/etc/rsyncd.conf'
      $service_name = 'rsync'
    }
    'RedHat','CentOS' : {
      $pkg_names    = ['xinetd','rsync']
      $conf_file    = '/etc/rsync.conf'
      $service_name = 'xinetd'
    }
    default: {
      fail("The ${module_name} module is not supporte\
 on an ${::operatingsystem} based system.")
    }
  }
}
