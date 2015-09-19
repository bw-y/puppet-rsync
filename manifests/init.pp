# rsync
#
# Author Name <baowei.y@gmail.com>
#
class rsync (
  # rsync 全局配置
  $port             = 873,
  $address          = '0.0.0.0',
  $uid              = 'root',
  $gid              = 'root',
  $use_chroot       = 'no',
  $read_only        = 'no',
  $max_conn         = 80,
  $pid_file         = '/var/run/rsyncd.pid',
  $lock_file        = '/var/run/rsyncd.lock',
  $log_file         = '/var/log/rsyncd.log',
  $timeout          = 180,
  $dir_keys         = '/etc/rsync_keys',

  # rsync 服务状态管理
  $service_ensure   = 'running',
  $service_enable   = true,

  # rsync 子配置文件生成
  $servers          = {},
  $servers_defaults = {
    'read_only' => false,
    'list'      => true,
    'uid'       => 'root',
    'gid'       => 'root',
  },

  $cmds             = {},
  $cmds_defaults    = {},
  # 运行阶段
  $stage            = 'runtime',

) inherits ::rsync::params {

  # stdlib/lib/puppet/parser/functions/hash_merge.rb
  $modules = hash_merge($servers, $servers_defaults)

  anchor { 'rsync::begin': } ->
  class { '::rsync::install': } ->
  class { '::rsync::config': } ~>
  class { '::rsync::service': } ->
  anchor { 'rsync::end': }

}
