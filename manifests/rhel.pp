# @example
#   include nodripa::install

class nodripa::rhel {

  yumrepo { 'puppet-tools':
    ensure         => present,
    name           => 'puppet-tools',
    baseurl        => "http://yum.puppet.com/puppet-tools/el/${facts['os']['release']['major']}/\$basearch",
    enabled        => '1',
    gpgcheck       => '0',
    before         => Package['puppet-bolt'],
  }
  package { 'puppet-bolt':
    ensure         => 'installed',
    provider       => yum,
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
