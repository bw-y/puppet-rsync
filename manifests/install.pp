# Class: rsync::install
#
# This class install package and create dir
#
class rsync::install {

  rsync::resource::pkg_check{$::rsync::pkg_names: ensure => present}

  file { $::rsync::dir_keys:
    ensure => directory,
    owner  => 0,
    group  => 0
  }

}
