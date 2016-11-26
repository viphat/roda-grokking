require_relative 'models'
require 'tilt/erubis'
require 'roda'
require 'logger'
require 'json'

Dir[__dir__ + '/helpers/*.rb'].each {|file| require file }

class RodaGrokking < Roda
  include HeatmapHelper
  plugin :default_headers,
    'Content-Type'=>'text/html',
    'Content-Security-Policy'=>"default-src 'self' style-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com https://oss.maxcdn.com/ https://maxcdn.bootstrapcdn.com https://*.gstatic.com https://*.googleapis.com https://maps.googleapis.com https://s3-ap-southeast-1.amazonaws.com",
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
  plugin :json
  plugin :head
  plugin :all_verbs
  plugin :assets, :js => 'heatmap.js'

  Unreloader.require('routes'){}

  route do |r|
    r.multi_route
    r.assets

    r.root do
      view 'index'
    end

    r.is "heatmap" do
      view "heatmap"
    end

    r.on 'api' do
      r.get 'heatmap' do
        response['Content-Type'] = 'application/json'
        locations = Log.get_top_locations(r['top'].to_i, Time.at(r['date'].to_i))
        lat_lng = get_lat_lng_of_locations
        locations.each do |location|
          loc = location[:location].downcase.split(" ").join(" ").to_sym
          location[:lat] = lat_lng[loc][0]
          location[:lng] = lat_lng[loc][1]
        end
        {
          locations: locations
        }
      end
    end

  end
end
