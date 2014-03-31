class gitolite (
  $gitpath = '/srv/git',
  $user    = 'git',
  $group   = $user,
  $admin_pub_key,
  $preseed = "/var/cache/debconf/gitolite.preseed"
) {

  user { $user:
    ensure => present,
    system => true,
    gid    => $group,
    home   => $gitpath,
  }

  group { $group:
    ensure => present,
    system => true,
  }

  file { $gitpath:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }

  file { $preseed:
    path    => $preseed,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('gitolite/gitolite.erb'),
  }

  exec { "/usr/bin/debconf-set-selections < $preseed":
    alias       => "debconf_update",
    require     => File[$preseed],
    subscribe   => File[$preseed],
    refreshonly => true;
  }

  package { "gitolite":
    ensure       => present,
    #responsefile => $preseed,
    require      => [File[$preseed, $gitpath],
                     User[$user],
                     Exec["debconf_update"]],
  }

}
