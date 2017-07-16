# Mongoid::DynamicClients

## Overview

`Mongoid::DynamicClients` helps your [MongoId](https://docs.mongodb.com/mongoid/master/#ruby-mongoid-tutorial) enabled 
apps talk to multiple MongoDB databases. It is **dynamic** in the sense that you do not necessary have to know the 
databases you're connecting to beforehand, instead you provide connection properties (i.e. auth. credentials, hosts etc) 
at runtime so you can get them gotten from a DB or receive from an other source. In the example below the connection 
properties come from the `config` hash:
 
```ruby
require "mongoid/dynamic_clients"

# the database to connect to:
config = { 
  database: "my_custom_db",
  hosts: ['https://foobar.mongo.com:27017'],
  options: {
    user: 'default_user',
    password: 'default_password',
    auth_source: 'admin'
   }
}

# connect and execute the block against that database:
with_mongoid_client(:my_custom_db, config) do
  Record.create!(foo: "bar")
end
```

## Status

Status of development.

Status of tests of the latest version deployed to rubygems

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid-dynamic_clients'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-dynamic_clients

### Overview

What does it do, why is it useful? 

Clarify terms - databases vs clients

Example of mongoid.yml with "default" client configured

Emphasis on the "default" client / database 


### Quick Start
Some verbiage and code samples

### How it works
Explain how Core Mongoid Threaded works, where the clients are stored and how that affects code

#### Integrating with Rails 5
Describe puma setup, how threads are managed and how that affects multi database connections

#### Integrating with Sidekiq
Describe the theading model behind sidekiq, provide a code sample of the use of dynamic clients in a sidekiq job

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mongoid-dynamic_clients. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).