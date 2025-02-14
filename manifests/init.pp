# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodripa
class nodripa (
  String $pe_console   = $settings::server,
  String $certname     = $trusted['certname'],
  String $ssl_dir      = "${settings::confdir}/ssl",
  String $vault_server = $settings::server,
  String $vault_token  = undef
) {
  include nodripa::config
  include nodripa::service
}
