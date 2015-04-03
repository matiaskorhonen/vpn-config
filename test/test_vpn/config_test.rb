require 'minitest_helper'

describe ::VPN::Config do
  it "has a version number" do
    ::VPN::Config::VERSION.wont_be_nil
  end

  it "has a path to the default data file" do
    ::VPN::Config::PROVIDERS_PATH.wont_be_nil
  end
end
