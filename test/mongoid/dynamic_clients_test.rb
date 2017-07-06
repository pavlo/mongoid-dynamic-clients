require "test_helper"

class Mongoid::DynamicClientsTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Mongoid::DynamicClients::VERSION
  end

  def test_it_does_something_useful
    assert Record.create(data: "data", client_identifier: "default")
  end

end

CLIENT_IDENTIFIERS = {
    client1: {
        database: "client1",
        hosts: ['localhost:27017'],
        options: {
            user: 'client1_user',
            password: 'client1_pass'
        }
    },
    client2: {
        database: "client2",
        hosts: ['localhost:27017'],
        options: {
            user: 'client2_pass',
            password: 'client2_pass'
        }
    }
}

class Record

  include Mongoid::Document

  field :data, type: String
  field :client_identifier, type: String

end
