require 'minitest_helper'

class TestVpn::Config < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Vpn::Config::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
