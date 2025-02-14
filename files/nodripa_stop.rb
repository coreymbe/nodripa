#!/opt/puppetlabs/puppet/bin/ruby

require 'puppet'
require 'yaml'
require_relative 'util/purge_node'
require_relative 'util/logger'

def main
  settings_file = '/etc/puppetlabs/puppet/nodripa/settings.yaml'
  settings = YAML.load_file(settings_file)

  pe_console = settings['pe_console']
  certname = settings['certname']
  ssl_dir = settings['ssl_dir']
  log = settings['log']

  logger = Nodripa::Logger.new(log)
  purge_node = Nodripa::PurgeNode.new(pe_console, ssl_dir, logger)
  purge_node.from_cert_authority(certname)
  purge_node.from_puppetdb(certname)

  paths = {
    'private key' => "#{ssl_dir}/private_keys/#{certname}.pem",
    'certificate' => "#{ssl_dir}/certs/#{certname}.pem",
  }

  paths.each_pair do |label, path|
    if Puppet::FileSystem.exist?(path)
      Puppet::FileSystem.unlink(path)
      logger.info("Successfully removed #{label} for #{certname}")
    end
  end
  logger.info("The node #{certname} has been purged")
end

if $PROGRAM_NAME == __FILE__
  main
end
