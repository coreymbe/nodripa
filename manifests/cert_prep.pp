# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodripa::cert_prep
class nodripa::cert_prep (
  String $pe_console = $settings::server,
  String $certname   = $settings::certname,
  String $ssl_dir    = "${settings::confdir}/ssl",
){

  file { "${settings::confdir}/nodripa":
    ensure => directory,
  }

  file { "${settings::confdir}/nodripa/ssl":
    ensure => directory,
    require => File["${settings::confdir}/nodripa"],
  }

  file { "${settings::confdir}/nodripa/ssl/certs":
    ensure => directory,
    require => File["${settings::confdir}/nodripa/ssl"],
  }

  file { "${settings::confdir}/nodripa/ssl/keys":
    ensure => directory,
    require => File["${settings::confdir}/nodripa/ssl"],
  }

  file { "${settings::confdir}/nodripa/ssl/certs/nodripa.pem":
    ensure => file,
    source => 'puppet:///modules/nodripa/ssl/certs/nodripa.pem',
    require => File["${settings::confdir}/nodripa/ssl/certs"],
  }
  
  file { "${settings::confdir}/nodripa/ssl/keys/nodripa.pem":
    ensure => file,
    source => 'puppet:///modules/nodripa/ssl/keys/nodripa.pem',
    require => File["${settings::confdir}/nodripa/ssl/keys"],
  }

  file { "${settings::confdir}/nodripa/settings.yaml":
    ensure  => file,
    content => epp('nodripa/settings.yaml.epp'),
    require => File["${settings::confdir}/nodripa"],
  }

  file { '/etc/systemd/system/nodripa.service':
    ensure => present,
    source => ['puppet:///modules/nodripa/nodripa.service'],
    notify => Service['nodripa'],
  }

  service { 'nodripa':
    ensure => running,
    enable => true,
  }

}
