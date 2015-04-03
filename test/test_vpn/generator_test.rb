require 'minitest_helper'

describe ::VPN::Config::Generator do
  let(:generator) { ::VPN::Config::Generator.new }

  describe "#providers" do
    it "loads the default providers" do
      generator.providers.size.must_equal 1
    end

    it "includes 'Private Internet Access' in the provider" do
      generator.providers.map {|p| p["name"] }.must_include("Private Internet Access")
    end
  end

  describe "#vpns" do
    it "includes the PIA VPNs by default" do
      generator.vpns.size.must_equal 20
    end
  end

  describe "#selected_provider" do
    it "selects the given provider" do
      generator.provider = "Private Internet Access"
      generator.selected_provider["name"].must_equal "Private Internet Access"
    end

    it "raises an error if the provider isn't found" do
      generator.provider = "Nope"
      ->{ generator.selected_provider }.must_raise(ArgumentError)
    end
  end

  describe "#enabled_vpns" do
    it "filters enabled VPNs by endpoints" do
      names = ["Canada", "US East"]
      generator.endpoints = names
      generator.enabled_vpns.size.must_equal 2

      names.each do |n|
        generator.enabled_vpns.map {|p| p["name"] }.must_include n
      end
    end

    it "selects all VPNs if no endpoints are specified" do
      generator.endpoints = nil
      generator.enabled_vpns.size.must_equal 20

      generator.endpoints = []
      generator.enabled_vpns.size.must_equal 20
    end
  end

  describe "#generate_plist" do
    it "generates a plist string" do
      string = generator.generate_plist
      string.must_include %{<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">}
      string.must_include %{<plist version="1.0">}
    end
  end

  describe "#generate_signed_plist" do
    it "generates a signed plist" do
      string = generator.generate_signed_plist
      p7 = OpenSSL::PKCS7.new(string)
      p7.signers.first.name.must_equal "/C=ZZ/ST=Sto Plains/L=Ankh-Morpork/O=The Patrician's Palace/OU=The Black Clerks/CN=The Patrician's Palace"
    end
  end

  describe "#default_p12" do
    it "loads the snake-oil certificate" do
      generator.send(:default_p12).must_be_instance_of ::OpenSSL::PKCS12
    end
  end

  describe "#p12" do
    it "returns the default p12 if no certificate is defined" do
      p12 = generator.send(:p12)
      p12.must_be_instance_of ::OpenSSL::PKCS12
      p12.certificate.subject.to_s.must_equal "/C=ZZ/ST=Sto Plains/L=Ankh-Morpork/O=The Patrician's Palace/OU=The Black Clerks/CN=The Patrician's Palace"
    end

    it "loads the certificate from the given path" do
      generator.certificate_path = File.expand_path("../../data/test.p12", __FILE__)
      generator.certificate_pass = "foobar"
      p12 = generator.send(:p12)
      p12.must_be_instance_of ::OpenSSL::PKCS12
      p12.certificate.subject.to_s.must_equal "/C=XX/ST=XXXX/L=XXXXXX/O=XXXXXXXX/OU=XXXXXXXXXX/CN=XXXXXXXXXXXX"
    end
  end

  describe "#config" do
    it "returns a hash of VPN configuration data" do
      config = generator.send(:config)
      config.must_be_instance_of Hash
      config["PayloadDisplayName"].must_equal "Private Internet Access"
    end
  end

end
