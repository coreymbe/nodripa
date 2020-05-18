# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodripa::debian

class nodripa::debian {

  apt::source { 'puppetlabs':
    ensure => present,
    location => 'http://apt.puppetlabs.com',
    repos    => 'puppet-tools',
    release => $facts['os']['distro']['codename'],
    allow_unsigned => true,
    before => Package['puppet-bolt'],
  }
  package { 'puppet-bolt':
    ensure => 'installed',
    provider => apt,
  }
  file {'/tmp/certname-replace.sh':
    ensure => present,
    source => ["puppet:///modules/nodripa/debian-certname-replace.sh"],
    mode => '0744',
    before => Service['nodripa'],
  }
  file {'/tmp/bolt-nodripa.sh':
    ensure => present,
    source => ["puppet:///modules/nodripa/bolt-nodripa.sh"],
    mode => '0744',
    before => Service['nodripa'],
  }
  file { '/root/.ssh/nodripa_rsa':
    ensure => present,
    content => $nodripa::ssh_key,
    mode => '0600',
  }
  file { '/etc/systemd/system/nodripa.service':
    ensure => present,
    source => ["puppet:///modules/nodripa/nodripa.service"],
    notify => Service['nodripa'],
  }
  service { 'nodripa':
    enable => true,
    ensure => running,
  }
}
