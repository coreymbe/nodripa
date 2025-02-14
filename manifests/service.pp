# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodripa::service
class nodripa::service {
  package { 'vault':
    ensure   => present,
    provider => 'puppet_gem',
    before   => Service['nodripa'],
  }

  systemd::unit_file { 'nodripa.service':
    ensure => present,
    source => 'puppet:///modules/nodripa/nodripa.service',
    notify => Service['nodripa'],
  }

  service { 'nodripa':
    ensure  => running,
    enable   => true,
    provider => 'systemd',
    require => Class['nodripa::config'],
  }
}
