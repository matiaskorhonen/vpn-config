if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start do
    add_filter 'test'
  end
else
  require "simplecov"
  SimpleCov.start do
    add_filter 'test'
  end
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "vpn/config"

require "minitest/autorun"
require "minitest/pride"
