# Class: rsync::config
#
# 按顺序生成指定的配置
#
class rsync::config {

  class { '::rsync::config::main': } ->
  class { '::rsync::config::server': } -> 
  class { '::rsync::config::cmd': }

  contain '::rsync::config::main'
  contain '::rsync::config::server'
  contain '::rsync::config::cmd'

}
