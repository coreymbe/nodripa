# @example
#   include nodripa

class nodripa (
  String $ssh_key,
  String $bolt_user,
  String $private_key,
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
