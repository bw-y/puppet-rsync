# Class: rsync::config::cmd
#
# 接收配置对应的hash对，实例化对应的rsync计划任务
#
class rsync::config::cmd {

  create_resources (
    'rsync::resource::cmd',
    $::rsync::cmds,
    $::rsync::cmds_defaults
  )

}
