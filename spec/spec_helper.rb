$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "arrcc"
require "rspec/core"
require "rspec/mocks"

ActiveRecord::Base.establish_connection YAML::load_file("#{File.dirname(__FILE__)}/config/database.yml")["test"]

load "#{File.dirname(__FILE__)}/fixtures/schema.rb"