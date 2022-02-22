require "yaml"
require "plist"
require "openssl"

module VPN
  module Config
    class Generator
      attr_accessor :auth_name, :auth_pass, :identifier, :certificate_path,
                    :certificate_pass, :provider, :endpoints, :data_file

      def initialize(auth_name: nil, auth_pass: nil, identifier: nil,
          certificate_path: nil, certificate_pass: nil, provider: nil,
          endpoints: nil, data_file: nil)
        @auth_name = auth_name
        @auth_pass = auth_pass
        @identifier = identifier || "com.example.vpn"
        @certificate_path = certificate_path
        @certificate_pass = certificate_pass
        @provider = provider || "Private Internet Access"
        @endpoints = endpoints
        @data_file = data_file || VPN::Config::PROVIDERS_PATH
      end

      def providers
        @providers ||= YAML.load_file(data_file)["providers"]
      end

      def selected_provider
        @selected_provider ||= begin
          prov = providers.find {|pr| pr["name"] == provider }
          if prov
            prov
          else
            raise ArgumentError, "Provider '#{provider}' not found"
          end
        end
      end

      def vpns
        @vpns ||= selected_provider["endpoints"]
      end

      def enabled_vpns
        if endpoints && endpoints.any?
          vpns.select {|e| endpoints.include? e["name"] }
        else
          vpns
        end
      end

      def generate_plist
        config.to_plist
      end

      def generate_signed_plist
        private_key = p12.key
        signing_cert = p12.certificate

        private_key = p12.key
        intermediate_certs = p12.ca_certs
        signing_cert = p12.certificate

        # Read configuration profile
        configuration_profile_data = generate_plist

        # Sign the configuration profile
        signing_flags = OpenSSL::PKCS7::BINARY
        signature = OpenSSL::PKCS7.sign(signing_cert, private_key,
                                        configuration_profile_data, intermediate_certs,
                                        signing_flags)

        signature.to_der
      end

      private

      def p12
        @p12 ||= begin
          if certificate_path
            path = File.expand_path(certificate_path)
            unless File.exist? path
              raise ArgumentError, "File not found: #{certificate_path}"
            end
            cert = File.read(path)
            OpenSSL::PKCS12.new(cert, certificate_pass)
          else
            default_p12
          end
        end
      end

      def default_p12
        @default_certificate ||= begin
          path = File.expand_path("../../../../snake-oil/certificate.p12", __FILE__)
          cert = File.read(path)
          OpenSSL::PKCS12.new(cert, "Swordfish")
        end
      end

      def config
        {
          "PayloadDescription" => "VPN settings for #{selected_provider["name"]}",
          "PayloadDisplayName" => selected_provider["name"],
          "PayloadIdentifier" => identifier,
          "PayloadOrganization" => "",
          "PayloadRemovalDisallowed" => false,
          "PayloadType" => "Configuration",
          "PayloadUUID" => selected_provider["uuid"],
          "PayloadVersion" => 1,

          "PayloadContent" => enabled_vpns.each_with_index.map do |vpn, index|
            {
              "EAP" => {},
              "IPSec" => {
                "AuthenticationMethod" => "SharedSecret",
                "SharedSecret" => StringIO.new(vpn["shared_secret"]),
              },
              "IPv4" => {
                "OverridePrimary" => 1
              },
              "PPP" => {
                "AuthName" => auth_name,
                "AuthPassword" => auth_pass,
                "TokenCard" => false,
                "CommRemoteAddress" => vpn["host"],
              },
              "PayloadDescription" => "Configures VPN settings, including authentication.",
              "PayloadDisplayName" => "VPN (#{vpn["name"]})",
              "PayloadIdentifier" => "#{identifier}.vpn#{index}",
              "PayloadOrganization" => "",
              "PayloadType" => "com.apple.vpn.managed",
              "PayloadUUID" => vpn["uuid"],
              "PayloadVersion" => 1,
              "Proxies" => {},
              "UserDefinedName" => vpn["name"],
              "VPNType" => "L2TP"
            }
          end
        }
      end
    end
  end
end
