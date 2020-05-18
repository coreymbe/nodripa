# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodripa

class nodripa (
  String $ssh_key
){

  case $facts['os']['name'] {
      'RedHat', 'CentOS':  {
           include nodripa::rhel
      }
      /^(Debian|Ubuntu)$/:  {
           include nodripa::debian
      }
      Default:  {
           include nodripa::rhel
      }
  }
}
