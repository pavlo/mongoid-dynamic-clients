module Mongoid
  module DynamicClients

    def with_mongoid_client(client_identifier, client_config = {})

      previous_client = Mongoid::Threaded.client_override
      cid = client_identifier.to_sym

      begin

        unless Mongoid::Config.clients[cid]
          Mongoid::Config.clients[cid] = client_config
          #Mongoid::Clients.with_name(cid).reconnect
        end

        Mongoid.override_client(cid)
        yield

      ensure
        Mongoid.override_client(previous_client)
      end
    end

  end
end