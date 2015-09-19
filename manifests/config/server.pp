# Class: rsync::config::server
#
# 接收配置对应的hash对，实例化对应的资源
#
class rsync::config::server {

  create_resources (
    'rsync::resource::server',
    $::rsync::servers,
    $::rsync::servers_defaults
  )

}
