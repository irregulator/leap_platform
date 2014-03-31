class site_git {
  tag 'leap_service'
  Class['site_config::default'] -> Class['site_git']

  $git = hiera('git')
  $gitadmin = $git['gitadmin']

  $ssh = hiera_hash('ssh')
  $keys = $ssh['authorized_keys']
  $gitadmin_key = $keys[$gitadmin]
  $admin_pub_key = "${gitadmin_key['type']} ${gitadmin_key['key']}"

  $gitpath = '/srv/leap/git'
  $user = 'git'

  class { 'gitolite':
    gitpath       => $gitpath,
    admin_pub_key => $admin_pub_key,
  }

}
