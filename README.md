# rsync

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)

## Overview
此模块用于管理rsync服务和rsync计划任务

## Usage
1. 配置rsync服务，监听本地目录/opt/abcd，密码abcd12354
2. 设置rsync计划任务，同步本地监听的目录到/opt/rsync_cmd_test
```
node 'www.bw-y.com'{
  class { '::rsync':
    servers => {
      abcd => {
        create    => true,
        read_only => 'false',
        list      => 'true',
        uid       => 'root',
        gid       => 'root',
        path      => '/opt/abcd',
        password  => 'abcd12354',
      }
    },
  cmds => {
    abcd => {
      password => 'abcd12354',
      uniq_str => 'asFEsdfWQsdf',
      src      => 'root@10.4.0.25::abcd',
      dest     => '/opt/rsync_cmd_test',
    },
  }
}
```

## Reference

### Classes

* rsync::params : 参数类，用于平台资源区分
* rsync::install : 安装和创建所需资源
* rsync::config : 管理rsync对应配置的资源创建顺序
  * rsync::config::main : rsync服务的主配置文件管理
  * rsync::config::server : 创建指定监听目录时的依赖资源引用管理(目录配置直接使用erb解析传递的hash参数)
  * rsync::config::cmd : 创建本地rsync计划任务时的资源引用
* rsync::service : 管理rsync服务(主要用于本机提供rsync服务时)
### Define resouces
* rsync::resource::pkg_check : 依赖包的资源状态检测和处理
* rsync::resource::server : 创建本地监听目录时的密码文件和路径创建(可选)，模块配置直接使用erb解析
* rsync::resource::cmd : 创建rsync计划任务的资源引用
### Parameters

[rsyncd.conf手册](https://download.samba.org/pub/rsync/rsyncd.conf.html)

#### `port`
见rsyncd.conf手册port     默认值: 873
#### `address`
见rsyncd.conf手册address  默认值: '0.0.0.0'
#### `uid`
见rsyncd.conf手册uid      默认值: 'root'
#### `gid`
见rsyncd.conf手册gid      默认值: 'root'
#### `use_chroot`
见rsyncd.conf手册use chroot      默认值: 'no'
#### `read_only`
见rsyncd.conf手册read only       默认值: 'no'
#### `max_conn`
见rsyncd.conf手册max connections 默认值: 80
#### `pid_file`
见rsyncd.conf手册pid file        默认值: '/var/run/rsyncd.pid'
#### `lock_file`
见rsyncd.conf手册lock file       默认值: '/var/run/rsyncd.lock'
#### `log_file`
见rsyncd.conf手册log file        默认值: '/var/log/rsyncd.log'
#### `timeout`
见rsyncd.conf手册timeout         默认值: 180
#### `dir_keys`
为每个监听的目录根据key名生成独立的密码文件在此目录内,有效值为一个目录路径(此目录的父目录必须存在)  默认值: '/etc/rsync_keys'
#### `service_ensure`
rsync服务的有效状态,有效值[running|stopped] 默认值: 'running'
#### `service_enable`
rsync服务是否开机启动,有效值[true(启动)|false(不启动)]    默认值: true
#### `servers`
配置对应的rsync监听目录,此配置的有效取值见rsync::resource::server 默认值: {} 

  * [注: 由于rsync配置文件的&include和&merge配置在ubuntu12.04上测试一直不通过,也就意味着,如果需要实现跨平台和自定义server配置,不可以使用配置解耦[每个单独的server独自生成的方式]的方法,因此,这里直接在rsync的主配置文件中使用erb语法直接解析此hash对,这样虽然解决了无法配置解耦的问题,但引入新的问题-无法使用create_resources创建资源,也就是无法使用默认值,最终会导致多个配置有重复的配置参数时,需要写多个,而为了解决此问题,这里笔者写了hash_merge函数(stdlib/lib/puppet/parser/functions/hash_merge.rb)解决,其说明见函数文档)]

#### `servers_defaults`
servers的默认值, 默认值: {'read_only' => false, 'list' => true, 'uid' => 'root', 'gid' => 'root'},
#### `cmds`
自定义添加rsync命令到计划任务中,有效数据类型hash  默认值: {}
#### `cmds_defaults`
cmds的默认值
#### `stage`
执行顺序，见stdlib::stages

## Limitations
此模块目前仅在ubuntu(10.04/12.04/14.04)和redhat(centos)5/6上测试通过。
