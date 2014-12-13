#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require "plist"
require "yaml"
require "pp"
require "securerandom"
require "base64"

server_yaml = "pia-servers.yml"

all_vpns = YAML.load_file("pia-servers.yml")
enabled_vpns = all_vpns.select {|vpn| vpn["enabled"]}

# Get the user's VPN username
print "VPN username (e.g. 'x1234567'): "
auth_name = gets.chomp("\n")

output_path = "generated.mobileconfig"

identifier = "fi.matiaskorhonen.pia"

# Ensure that all the VPNs have UUIDs
all_vpns.map do |vpn|
  vpn["uuid"] ||= SecureRandom.uuid
  vpn["uuid"].upcase!
  vpn
end
File.open(server_yaml, "w") {|f| f.write YAML.dump(all_vpns) }


puts "Generating configuration profile…"
config = {
  "PayloadDescription" => "VPN settings for Private Internet Access",
  "PayloadDisplayName" => "Private Internet Access",
  "PayloadIdentifier" => identifier,
  "PayloadOrganization" => "",
  "PayloadRemovalDisallowed" => false,
  "PayloadType" => "Configuration",
  "PayloadUUID" => "59C4DCB3-1F43-4D22-BBA4-1EF8FDED8960",
  "PayloadVersion" => 1,

  "PayloadContent" => enabled_vpns.each_with_index.map do |vpn, index|
    puts "-> #{vpn["host"]}"

    {
      "EAP" => {},
      "IPSec" => {
        "AuthenticationMethod" => "SharedSecret",
        "SharedSecret" => StringIO.new("mysafety"),
      },
      "IPv4" => {
        "OverridePrimary" => 1
      },
      "PPP" => {
        "AuthName" => auth_name,
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

File.open(output_path, "w") {|f| f.write config.to_plist }

puts "Wrote configuration profile to: #{output_path}"
