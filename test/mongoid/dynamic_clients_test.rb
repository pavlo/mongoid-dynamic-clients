require "test_helper"
require "mongoid/dynamic_clients"

class Mongoid::DynamicClientsTest < Minitest::Test

  include Mongoid::DynamicClients

  def setup
    @default = new_raw_client(:default)
    @default[:records].drop

    @client1 = new_raw_client(:client1)
    @client1[:records].drop

    @client2 = new_raw_client(:client2)
    @client2[:records].drop
  end


  def test_that_it_has_a_version_number
    refute_nil ::Mongoid::DynamicClients::VERSION
  end

  def test_it_uses_default_client
    assert Record.create(data: "#test_it_uses_default_client", client_identifier: "default")
    assert_equal 1, @default[:records].count
  end

  def test_it_switches_client

    data = "some data"

    Record.create(data: data, client_identifier: "default")

    with_mongoid_client(:client1, CLIENT_CONFIGS[:client1]) do
      Record.create(data: data, client_identifier: "client1")
      Record.create(data: data, client_identifier: "client1")
    end

    assert_equal 1, @default[:records].count
    @default[:records].find.each do |document|
      assert_equal "default", document[:client_identifier]
    end

    assert_equal 2, @client1[:records].count
    @client1[:records].find.each do |document|
      assert_equal "client1", document[:client_identifier]
    end

    assert_equal 0, @client2[:records].count
  end

  def test_it_restores_previous_client

    data = "some data"

    Record.create(data: data, client_identifier: "default")

    with_mongoid_client(:client1, CLIENT_CONFIGS[:client1]) do
      Record.create(data: data, client_identifier: "client1")
      Record.create(data: data, client_identifier: "client1")
    end

    Record.create(data: data, client_identifier: "default")

    with_mongoid_client(:client2, CLIENT_CONFIGS[:client2]) do
      Record.create(data: data, client_identifier: "client2")

      with_mongoid_client(:client1, CLIENT_CONFIGS[:client2]) do
        Record.create(data: data, client_identifier: "client1")
      end

      Record.create(data: data, client_identifier: "client2")
    end

    Record.create(data: data, client_identifier: "default")
    Record.create(data: data, client_identifier: "default")

    assert_equal 4, @default[:records].count
    @default[:records].find.each do |document|
      assert_equal "default", document[:client_identifier]
    end

    assert_equal 3, @client1[:records].count
    @client1[:records].find.each do |document|
      assert_equal "client1", document[:client_identifier]
    end

    assert_equal 2, @client2[:records].count
    @client2[:records].find.each do |document|
      assert_equal "client2", document[:client_identifier]
    end

  end

  def test_random_clients

    stats = {}

    1000.times do
      c = CLIENT_CONFIGS.keys.shuffle.first
      with_mongoid_client(c, CLIENT_CONFIGS[c]) do
        Record.create(data: "some data", client_identifier: c)
        stats[c] = stats[c] ? stats[c] + 1 : 1
      end
    end

    assert_equal 3, stats.keys.count

    stats.keys.each do |k|
      assert_equal stats[k], instance_variable_get("@#{k}")[:records].count
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
        hosts: ['localhost:27018'],
        options: {
            user: 'client1_user',
            password: 'client1_password',
            auth_source: 'admin'
        }
    },
    client2: {
        database: "client2",
        hosts: ['localhost:27019'],
        options: {
            user: 'client2_user',
            password: 'client2_password',
            auth_source: 'admin'
        }
    }
}

class Record

  include Mongoid::Document

  field :data, type: String
  field :client_identifier, type: String

end
