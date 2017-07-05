require "test_helper"

class Mongoid::DynamicClientsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mongoid::DynamicClients::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
end
