# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodripa::install

class nodripa::install {

  yumrepo { 'puppet-tools':
    name => "puppet-tools",
    ensure => present,
    baseurl => "http://yum.puppet.com/puppet-tools/el/${facts['os']['release']['major']}/\$basearch",
    enabled => '1',
    gpgcheck => '0',
    before => Package['puppet-bolt'],
  }
  package { 'puppet-bolt':
    ensure => 'installed',
    provider => yum,
  }
  file {'/tmp/certname-replace.sh':
    ensure => present,
    source => ["puppet:///modules/nodripa/certname-replace.sh"],
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
