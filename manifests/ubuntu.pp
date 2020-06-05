# @example
#   include nodripa::ubuntu
class nodripa::ubuntu {

  apt::source { 'puppetlabs':
    ensure         => present,
    location       => 'http://apt.puppetlabs.com',
    repos          => 'puppet-tools',
    release        => $facts['os']['distro']['codename'],
    allow_unsigned => true,
    before         => Package['puppet-bolt'],
  }
  package { 'puppet-bolt':
    ensure         => 'installed',
    provider       => apt,
  }
  file {'/tmp/certname-replace.sh':
    ensure         => present,
    source         => ['puppet:///modules/nodripa/certname-replace.sh'],
    mode           => '0744',
    before         => Service['nodripa'],
  }
  file {'/tmp/bolt-nodripa.sh':
    ensure         => present,
    content        => epp('nodripa/bolt-nodripa.sh.epp'),
    mode           => '0744',
    before         => Service['nodripa'],
  }
  file {'/tmp/pe-version_ssl-clean.sh':
    ensure         => present,
    source         => ['puppet:///modules/nodripa/pe-version_ssl-clean.sh'],
    mode           => '0744',
    before         => Service['nodripa'],
  }
  file { $nodripa::ssh_key:
    ensure         => present,
    content        => $nodripa::private_key,
    mode           => '0600',
  }
  file { '/etc/systemd/system/nodripa.service':
    ensure         => present,
    source         => ['puppet:///modules/nodripa/nodripa.service'],
    notify         => Service['nodripa'],
  }
  service { 'nodripa':
    ensure         => running,
    enable         => true,
  }
}