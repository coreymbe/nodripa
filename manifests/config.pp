# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodripa::config
class nodripa::config {
  file { "${settings::confdir}/nodripa":
    ensure => directory,
  }

  file { "${settings::confdir}/nodripa/reaper":
    ensure  => directory,
    require => File["${settings::confdir}/nodripa"],
  }

  file { "${settings::confdir}/nodripa/ssl":
    ensure  => directory,
    require => File["${settings::confdir}/nodripa"],
  }

  file { "${settings::confdir}/nodripa/reaper/util":
    ensure  => directory,
    recurse => 'remote',
    source  => 'puppet:///modules/nodripa/util',
    require => File["${settings::confdir}/nodripa/reaper"],
  }

  file { "${settings::confdir}/nodripa/reaper/nodripa_start.rb":
    ensure => file,
    mode => '0744',
    source => 'puppet:///modules/nodripa/nodripa_start.rb',
    require => File["${settings::confdir}/nodripa/reaper"],
  }

  file { "${settings::confdir}/nodripa/reaper/nodripa_stop.rb":
    ensure => file,
    mode => '0744',
    source => 'puppet:///modules/nodripa/nodripa_stop.rb',
    require => File["${settings::confdir}/nodripa/reaper"],
  }

  file { "${settings::confdir}/nodripa/ssl/certs":
    ensure  => directory,
    require => File["${settings::confdir}/nodripa/ssl"],
  }

  file { "${settings::confdir}/nodripa/ssl/keys":
    ensure  => directory,
    require => File["${settings::confdir}/nodripa/ssl"],
  }

  file { "${settings::confdir}/nodripa/log":
    ensure  => directory,
    require => File["${settings::confdir}/nodripa"],
  }

  file { "${settings::confdir}/nodripa/log/reaper.log":
    ensure  => file,
    require => File["${settings::confdir}/nodripa"],
  }

  file { "${settings::confdir}/nodripa/settings.yaml":
    ensure  => file,
    content => epp('nodripa/settings.yaml.epp'),
    require => File["${settings::confdir}/nodripa"],
  }
}
