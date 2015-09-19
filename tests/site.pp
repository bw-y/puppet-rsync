# nothing

node 
  'ubt14-04.mos.com',
  'ubt12-04.lab.com'
{
  class { '::nginx':
    log_files => {
      aa => '/var/log/nginx/irs/access.log',
      bb => '/var/log/nginx/iwt_access.log',
    },
    vhosts => {
      tmpserver => {
        upstream      => true,
        real_servers  => ['10.7.0.11:80 fail_timeout=0', '10.1.0.96:80 fail_timeout=2'],
        server_name   => 'www.bw-y.com',
        k_timeout     => 5,
        gzip_types    => 'text/plain application/x-javascript text/css application/xml',
      }
    },
    locations => {
      root => { superior => 'tmpserver' }
    },
    tracker_logrotate => {
      irs => { 
        log_file_tag => 'aa',
        dpath        => '/opt/tracker_irs_tar'
      }
    },
    tracker_servers_defaults => {
      server_name  => 'irs01.com letv.irs01.com sohu.irs01.com',
      root         => ['/home/irt/static', '/home/irt'],
      static_dir   => 'default',
      log_file_tag => 'aa',
    },
    tracker_servers => {
      'irs'     => {},
      'irs_ssl' => { port => 443, ssl_pem => 'irs01.pem' },
    },
    tracker_locations_defaults => {
      location  => '= /irt',
    },
    tracker_locations => {
      'irt_irs'     => { superior => 'irs', log_file_tag => 'aa' },
      'irt_irs_ssl' => { superior => 'irs_ssl', log_file_tag => 'aa' },
    }
  }
  class { '::rsync':
    servers_defaults => {
      create    => true,
      read_only => 'false',
      list      => 'true',
      uid       => 'root',
      gid       => 'root',
    },
    servers => {
      abcd => {
        path      => '/opt/abcd',
        password  => 'abcd12354',
      },
      abce => {
        path     => '/opt/abce',
        password => 'asdf234sdf',
      } 
    },
    cmds => {
      irs => {
        ensure   => absent,
        password => 'abcd12354',
        uniq_str => 'asFEsdfWQsdf',
        src      => 'root@10.4.0.25::abcd',
        dest     => '/opt/rsync_cmd_test',
      },
      abce => {
        ensure   => absent,
        uniq_str => 'sdDFas234WA',
        args     => '-a --delete -e "ssh -p 22"',
        src      => '10.4.0.25:/opt/abcd/',
        dest     => '/opt/rsync_cmd_test',
      }
    }
  }
}
