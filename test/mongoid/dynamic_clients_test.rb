require "test_helper"

class Mongoid::DynamicClientsTest < Minitest::Test

  def setup
    @raw_client_default = new_raw_client(:default)
    @raw_client_default[:records].drop
  end


  def test_that_it_has_a_version_number
    refute_nil ::Mongoid::DynamicClients::VERSION
  end

  def test_it_uses_default_client
    assert Record.create(data: "#test_it_uses_default_client", client_identifier: "default")
    assert_equal 1, @raw_client_default[:records].count

    @raw_client_default[:records].find.each do |document|
      puts document.inspect
    end
  end

  private
  def new_raw_client(client_identifier)
    c = CLIENT_CONFIGS[client_identifier]

    Mongo::Client.new(c[:hosts],
                      database: c[:database],
                      auth_source: c[:options][:auth_source],
                      user: c[:options][:user],
                      password: c[:options][:password])
  end

end

CLIENT_CONFIGS = {
    default: {
        database: "default",
        hosts: ['localhost:27017'],
        options: {
            user: 'default_user',
            password: 'default_password',
            auth_source: 'admin'
        }
    },
    client1: {
        database: "client1",
        hosts: ['localhost:27017'],
        options: {
            user: 'client1_user',
            password: 'client1_pass',
            auth_source: 'admin'
        }
    },
    client2: {
        database: "client2",
        hosts: ['localhost:27017'],
        options: {
            user: 'client2_pass',
            password: 'client2_pass',
            auth_source: 'admin'
        }
    }
}

class Record

  include Mongoid::Document

  field :data, type: String
  field :client_identifier, type: String

end
