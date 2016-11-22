require_relative 'models'

require 'tilt/erubis'
require 'roda'

class RodaGrokking < Roda
  plugin :default_headers,
    'Content-Type'=>'text/html',
    'Content-Security-Policy'=>"default-src 'self' https://oss.maxcdn.com/ https://maxcdn.bootstrapcdn.com https://ajax.googleapis.com",
    #'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
    'X-Frame-Options'=>'deny',
    'X-Content-Type-Options'=>'nosniff',
    'X-XSS-Protection'=>'1; mode=block'

  use Rack::Session::Cookie,
    :key => '_RodaGrokking_session',
    #:secure=>!TEST_MODE, # Uncomment if only allowing https:// access
    :secret=>File.read('.session_secret')

  plugin :csrf
  plugin :render, :escape=>true
  plugin :multi_route

  Unreloader.require('routes'){}

  route do |r|
    r.multi_route

    r.root do
      view 'index'
    end
  end
end
