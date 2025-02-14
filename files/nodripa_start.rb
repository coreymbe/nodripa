#!/opt/puppetlabs/puppet/bin/ruby

require 'fileutils'
require 'json'
require 'puppet'
require 'vault'
require 'yaml'

def main
  settings_file = '/etc/puppetlabs/puppet/nodripa/settings.yaml'
  settings = YAML.load_file(settings_file)

  ssl_dir = settings['ssl_dir']
  pe_server    = settings['pe_console']
  pe_ca        = "#{settings['ssl_dir']}/certs/ca.pem"
  vault_server = "https://#{settings['vault_server']}:8200"
  vault_token  = settings['vault_token']

  ssl_options = {
    ssl_context: {
      ca_cert: pe_ca,
      verify_peer: false
    }
  }
  
  pe_client = Puppet.runtime[:http]
  pe_session = pe_client.create_session
  pe_request = Puppet::HTTP::Service::Ca.new(pe_client,pe_session,pe_server,nil)
  pe_response = pe_request.get_certificate('nodripa', ssl_context: {verify_peer: false})
  
  Vault.configure do |config|
    config.address = vault_server
    config.token = vault_token
    config.ssl_ca_path = pe_ca
    config.ssl_verify = false
  end
  
  secret = Vault.logical.read('secret/nodripa')
  
  File.write('/etc/puppetlabs/puppet/nodripa/ssl/certs/nodripa.pem', pe_response.last())
  File.write('/etc/puppetlabs/puppet/nodripa/ssl/keys/nodripa.pem', secret.data[:key])
end

if $PROGRAM_NAME == __FILE__
  main
end
