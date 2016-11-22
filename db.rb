require_relative '.env.rb'

require 'sequel'

# Delete DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  DATABASE_URL may contain passwords.
# DB = Sequel.connect(ENV.delete('DATABASE_URL'))
DB = Sequel.connect(
  adapter: ENV.delete('DATABASE_ADAPTER'),
  database: ENV.delete('DATABASE_NAME'),
  host: ENV.delete('DATABASE_HOST'),
  user: ENV.delete('DATABASE_USER'),
  password: ENV.delete('DATABASE_PASSWORD'),
  port: ENV.delete('DATABASE_PORT')
)
