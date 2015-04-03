require "vpn/config/version"
require "vpn/config/generator"

module VPN
  module Config
    PROVIDERS_PATH = File.expand_path("../../../data/providers.yml", __FILE__)
  end
end
