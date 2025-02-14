require 'json'
require 'net/http'
require 'openssl'
require 'uri'

module Nodripa
  class PeHttp
    attr_accessor :pe_console, :ssl_dir

    def initialize(pe_console, ssl_dir)
      conf_dir = '/etc/puppetlabs/puppet/nodripa'
      @pe_console = pe_console
      @content_type = 'application/json'
      @req_options = {
        use_ssl: true,
        verify_mode: OpenSSL::SSL::VERIFY_NONE,
        ca_file: "#{ssl_dir}/certs/ca.pem",
        cert: OpenSSL::X509::Certificate.new(File.read("#{conf_dir}/ssl/certs/nodripa.pem")),
        key: OpenSSL::PKey::RSA.new(File.read("#{conf_dir}/ssl/keys/nodripa.pem")),
      }
    end

    def pe_post_request(body, port, uri)
      url = URI.parse("https://#{pe_console}:#{port}/#{uri}")
      http = Net::HTTP.start(
        url.host,
        url.port,
        @req_options,
      )
      request = Net::HTTP::Post.new(url)
      request.content_type = @content_type
      request.body = body.to_json

      response = http.request(request)
      response
    end

    def pe_put_request(body, port, uri)
      url = URI.parse("https://#{pe_console}:#{port}/#{uri}")
      http = Net::HTTP.start(
        url.host,
        url.port,
        @req_options,
      )
      request = Net::HTTP::Put.new(url)
      request.content_type = @content_type
      request.body = body.to_json

      response = http.request(request)
      response
    end
  end
end
