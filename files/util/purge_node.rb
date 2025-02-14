require_relative 'pe_http'

module Nodripa
  class PurgeNode < Nodripa::PeHttp
    attr_reader :pe_console, :ssl_dir

    def initialize(pe_console, ssl_dir, logger)
      super(pe_console, ssl_dir)
      @logger = logger
    end

    def from_cert_authority(certname)
      port = 8140
      uri = 'puppet-ca/v1/clean'
      body = { 'certnames': [certname.to_s] }

      response = pe_put_request(body, port, uri)
      if response.is_a? Net::HTTPOK
        @logger.info("Puppet CA revoked certificate for #{certname}")
      else
        @logger.error("Failed to revoke certificate for #{certname}")
      end
    end

    def from_puppetdb(certname)
      port = 8081
      uri = 'pdb/cmd/v1'
      body = { 'command' => 'deactivate node',
              'version' => 3,
              'payload' => {
                'certname' => certname.to_s
              } }

      response = pe_post_request(body, port, uri)
      if response.is_a? Net::HTTPOK
        @logger.info("Removed #{certname} from PuppetDB")
      else
        @logger.error("Failed to remove #{certname} from PuppetDB")
      end
    end
  end
end
