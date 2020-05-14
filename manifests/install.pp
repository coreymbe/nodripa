# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodripa::install

class nodripa::install {

  file { '/tmp/puppet-bolt.rpm':
    source => ["https://yum.puppet.com/puppet-tools/el/7/x86_64/puppet-bolt-2.9.0-1.el7.x86_64.rpm"],
    ensure => present,
    before => Package['puppet-bolt'],
  }
  package { 'puppet-bolt':
    ensure => 'installed',
    provider => rpm,
    source => ["/tmp/puppet-bolt.rpm"],
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
