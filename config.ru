dev = ENV['RACK_ENV'] == 'development'

if dev
  require 'logger'
  logger = Logger.new($stdout)
end

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(:subclasses=>%w'Roda Sequel::Model', :logger=>logger, :reload=>dev){RodaGrokking}
require_relative 'models'
Unreloader.require('app.rb'){'RodaGrokking'}
run(dev ? Unreloader : RodaGrokking.freeze.app)
