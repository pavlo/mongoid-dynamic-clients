# Mongoid::DynamicClients

todo: Status of development, testing badges, code quality and rubygems version

## Overview

`Mongoid::DynamicClients` helps your [MongoId](https://docs.mongodb.com/mongoid/master/#ruby-mongoid-tutorial) enabled 
apps talk to multiple MongoDB databases. It is **dynamic** in the sense that you do not necessary have to know the 
databases you're connecting to beforehand, instead you provide connection properties (i.e. auth. credentials, hosts etc) 
at runtime so you can get them gotten from a DB or receive from an other source. 

In the example below the connection properties come from the `config` hash:
 
```ruby
require "mongoid/dynamic_clients"

# the database to connect to:
config = { 
  database: 'my_custom_db',
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

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid-dynamic_clients'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-dynamic_clients

### Documentation

`Mongoid::DynamicClients` extends [MongoId](https://docs.mongodb.com/mongoid/master/#ruby-mongoid-tutorial) a little bit
to make it easier to switch databases at runtime without the need to configure them all in `mongoid.yml` file. This 
is helpful when you do not know the databases you're connecting to at the build time, say you're developing a multi-tenancy
or a white-labeable application where every tenant has its own database and you do not have the ability to enumerate them
all in `mongoid.yml`.

#### Terms: Clients or Databases?

Let's put it straight - both `clients` and `databases` terms are used interchangeably in this document. It is because 
MongoId (and the underlying mongodb driver) use the mention of `client` - a thing that is responsible for maintaining 
connections to the database and perform basic operations against it. Regular people though would call it `database` - 
i.e. _let it connect to database A and then connect to database B_... So the document uses the two terms in the same meaning
so both, experienced and regular developers would understand what's going on here.

#### The `default` client / database
 
When MongoId gem is installed and set up, it generates a `mongoid.yml` config file. The file features a single client 
(database) that is used by default and has the name of **_default_**: 

```yaml
production:
  # Configure available database clients. (required)
  clients:
    # Defines the default client. (required)
    default:
      database: default
      hosts:
        - 'localhost:27017'
      options:
        user: 'default_user'
        password: 'default_password'
        auth_source: admin
```

This is default client/database the application will use when it starts up.


#### Switch the clients / databases

The idea of the `Mongoid::DynamicClients` is to switch the databases at runtime, for this it provides a single `with_mongoid_client` method
that takes care of the job:

```ruby

# this goes to the `default` database
Record.create!()

# queries within the block go to the `my_custom_db` database
with_mongoid_client(:my_custom_db, config) do
  Record.create!() 
end

# this goes back to the `default` database
Record.create!() 
```

_(the code above assumes that `Record` is a [MongoId document](https://docs.mongodb.com/mongoid/master/tutorials/mongoid-documents/))_

#### Configuring the client

The second argument of the `with_mongoid_client` method is a configuration hash. It is supposed to convey connection 
information for given database. The structure of the config hash is the reflection of the `client` structure seen 
in `mongoid.yml` file above:

```yaml

default:
  database: default
  hosts:
    - 'localhost:27017'
  options:
    user: 'default_user'
    password: 'default_password'
    auth_source: adminkm

```

so, `config` hash should be a structure like this:

```ruby

config = {
  database: 'default',
  hosts: [ 'localhost:27017' ],
  options: {
    user: 'default_user',
    password: 'default_password',
    auth_source: 'admin'
  }
}

with_mongoid_client(:my_custom_db, config) do
  Record.create!() 
end

```

_Note: any other client option aavailable in `mongoid.yml` can be specified in the configuration hash, so that's how you
may configure connection pooling and other options for the clients._


### How it works
todo: Explain how Core Mongoid Threaded works, where the clients are stored and how that affects code

#### Integrating with Rails 5
todo: Describe puma setup, how threads are managed and how that affects multi database connections

#### Integrating with Sidekiq
todo: Describe the theading model behind sidekiq, provide a code sample of the use of dynamic clients in a sidekiq job

#### Possible traps

todo: It is easy to get out of connection pool limits by passing connection pool configuration to `with_mongoid_client` - explain the danger of that.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mongoid-dynamic_clients. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).