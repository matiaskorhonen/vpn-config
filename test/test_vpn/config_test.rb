require 'minitest_helper'

describe ::VPN::Config do
  it "has a version number" do
    _(::VPN::Config::VERSION).wont_be_nil
  end

  it "has a path to the default data file" do
    _(::VPN::Config::PROVIDERS_PATH).wont_be_nil
  end
end
