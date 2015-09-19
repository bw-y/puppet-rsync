# Definition: rsync::resource::cmd
#
# 创建rsync计划任务
#
# Parameters:
#   [*ensure*]             - (可选项)创建或删除对应的计划任务资源
#     有效值(present|absent).               默认值 present
#   [*password*]           - (可选项)计划任务是否需要密码
#     有效值:密码字段                       默认值 undef(未定义)
#   [*src*]                - (必填项)源路径
#     有效值:本地路或远程路径               默认值 undef(未定义)
#   [*dest*]               - (必填项)目标路径
#     有效值:本地路或远程路径               默认值 undef(未定义)
#   [*uniq_str*]           - (可选项)用于判断此计划任务在内存中的唯一值的关键字
#     有效值:大小写8-16位字段               默认值 'WaLyYz2ev'
#   [*args*]               - (可选项)rsync命令的参数
#     有效值:rsync的有效参数                默认值 '-a'
#   [*cron_min*]           - (可选项)此计划任务的分钟单位
#     有效值:crontab的分钟取值              默认值 '*'
#   [*cron_hour*]          - (可选项)此计划任务的小时单位
#     有效值:crontab的小时取值              默认值 '*'
#   [*cron_day*]           - (可选项)此计划任务的天单位
#     有效值:crontab的天取值天              默认值 '*'
#   [*owner*]              - (可选项)用于文件和计划任务所属用户,不要使用uid
#     有效值:有效的用户名                   默认值 'root'
#   [*group*]              - (可选项)用于创建相关文件的组属性
#     有效值:有效gid                        默认值 0
#   [*cmd_keys*]           - (可选项)当rsync命令需要调用密码时,所产生的密码文件存放目录
#     有效值:有效路径字符串,路径的父目录需已存在  默认值 '/etc/rsync.cmd.keys'
define rsync::resource::cmd(
  $ensure    = present,
  $password  = undef,
  $src       = undef,
  $dest      = undef,
  $uniq_str  = 'WaLyYz2ev',
  $args      = '-a',
  $cron_min  = '*',
  $cron_hour = '*',
  $cron_day  = '*',
  $owner     = 'root',
  $group     = 0,
  $cmd_keys  = '/etc/rsync.cmd.keys',
){

  File{
    owner  => $owner,
    group  => $group,
  }

  if $password {

    if !defined(File[$cmd_keys]) {
      file{ $cmd_keys:
        ensure => directory,
        mode   => '0755',
      }
    }
    $key_file = "${cmd_keys}/${name}.key"
    file { $key_file:
      mode    => '0600',
      content => $password
    }

    $rsync_cmd = "ps axu|grep '${uniq_str}'|grep -v grep \
|| /usr/bin/rsync ${args} --exclude='${uniq_str}' ${src} \
${dest} --password-file=${key_file}"

  } else {

    $rsync_cmd = "ps axu|grep '${uniq_str}'|grep -v grep \
|| /usr/bin/rsync ${args} --exclude='${uniq_str}' ${src} ${dest}"

  }

  cron { "rsync_cmd_${name}":
    ensure      => $ensure,
    command     => $rsync_cmd,
    user        => $owner,
    minute      => $cron_min,
    hour        => $cron_hour,
    monthday    => $cron_day,
  }
}
