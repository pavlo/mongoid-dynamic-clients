$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "mongoid/dynamic_clients"

require 'active_support'
require 'mongoid'

require "minitest/autorun"

ENV["MONGOID_ENV"] = "test"
Mongoid.load!( File.join(File.dirname(__FILE__), "mongoid.yml") )
