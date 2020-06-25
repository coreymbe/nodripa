# @example
#   include nodripa

class nodripa (
  String $ssh_key,
  String $bolt_user,
  String $private_key,
  String $bolt_transport,
  String $master_url,
  String $access_token,
){
  case $facts['os']['name'] {
      'RedHat', 'CentOS':  {
           include nodripa::rhel
      }
      'Debian', 'Ubuntu':  {
           include nodripa::ubuntu
      }
      default:  {
           include nodripa::rhel
      }
  }
}
