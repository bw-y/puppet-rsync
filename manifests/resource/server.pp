# Definition: rsync::resource::server
#
# 创建rsync计划任务
#
# Parameters:
#   [*ensure*]             - (可选项)创建或删除对应的文件资源
#     有效值(present|absent).               默认值 present
#   [*path*]               - (必填项)rsync所监听的目录
#     有效值:一个存在的目录                 默认值 undef(未定义)
#   [*create*]             - (可选项)path对应的目录是否由puppet创建,主要用于测试
#     有效值:true|false                     默认值 false
#   [*read_only|list*]     - (可选项)此处无使用,此参数为了兼容init.pp中servers的参数存在
#   [*uid|gid*]            - (可选项)主要用于创建文件和key时的属性设置
#     有效值:有效的用户名和组名             默认值 root
#   [*password*]           - (可选项)当前server的访问密码
#     有效值:有效的密码字串                 默认值 'rsyncpass'
define rsync::resource::server(
  $ensure     = 'present',
  $path       = undef,
  $create     = false,
  $read_only  = false,
  $list       = true,
  $uid        = 'root',
  $gid        = 'root',
  $password   = 'rsyncpass',
){

  $server_tag = $name
  $pass_file  = "${::rsync::dir_keys}/${name}.key"
  if $path == undef {
    fail('invalid path, $path must be a valid path')
  }

  File{
    owner  => $uid,
    group  => $gid,
  }

  file { $pass_file:
    mode    => '0600',
    content => "${uid}:${password}"
  }

  if $create {
    if !defined(File[$path]){
      file { $path:
        ensure => directory,
        mode   => '0755'
      }
    }
  }

}
