require "thor"
require "vpn/config"

module VPN
  module Config
    class CLI < Thor
      include Thor::Actions

      desc "generate OUTPUT_FILE", "Generate a VPN .mobileconfig file for OS X or iOS. \n\nSigning uses a self-signed snake-oil certificate by default."

      method_option :username, type: :string, required: true, banner: "VPN_USERNAME", aliases: "-u"
      method_option :password, type: :string, required: true, banner: "VPN_PASSWORD", aliases: "-p"
      method_option :endpoints, type: :array, default: [], banner: "VPN_ENDPOINTS", aliases: "-e"
      method_option :provider, type: :string, default: "Private Internet Access", banner: "VPN_PROVIDER", required: false, aliases: "-w"
      method_option :identifier, type: :string, required: false, default: "com.example.vpn", aliases: "-i"
      method_option :certificate_path, type: :string, required: false, banner: "PKCS12_CERTIFICATE", aliases: "-C"
      method_option :certificate_pass, type: :string, required: false, banner: "PASSPHRASE", aliases: "-P"
      method_option :sign, type: :boolean, default: false, aliases: "-S"
      def generate(output_file)
        generator = VPN::Config::Generator.new(
          auth_name: options[:username],
          auth_pass: options[:password],
          identifier: options[:identifier],
          certificate_path: options[:certificate_path],
          certificate_pass: options[:certificate_pass]
        )

        plist = if options[:sign]
          generator.generate_signed_plist
        else
          generator.generate_plist
        end

        if output_file.nil? || output_file.empty?
          puts plist
        else
          unless output_file =~ /\.(mobileconfig|plist)\z/i
            output_file = output_file + ".mobileconfig"
          end

          out_path = File.expand_path(output_file)
          puts "Writing to: #{out_path}"

          File.open(output_file, "wb") do |f|
            f << plist
          end
        end
      end

      desc "providers", "List known VPN providers"
      method_option :verbose, type: :boolean, default: false, aliases: "-v"
      def providers
        generator = VPN::Config::Generator.new
        generator.providers.each do |pr|
          puts "* " + pr["name"]
          if options[:verbose]
            puts "  * URL: " + pr["url"]
            puts "  * UUID: " + pr["uuid"]
          end
        end
      end

      desc "endpoints PROVIDER", "List known VPN endpoints for a given provider"
      method_option :verbose, type: :boolean, default: false, aliases: "-v"
      def endpoints(provider)
        generator = VPN::Config::Generator.new
        provider = generator.providers.find {|pr| pr["name"] =~ Regexp.new(provider, Regexp::IGNORECASE) }
        if provider
          provider["endpoints"].each do |e|
            puts "* " + e["name"]
            if options[:verbose]
              puts "  * Host: " + e["host"]
              puts "  * UUID: " + e["uuid"]
              puts "  * SharedSecret: " + e["shared_secret"]
            end
          end
        else
          abort "No provider found"
        end
      end
    end
  end
end
