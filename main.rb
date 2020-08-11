require 'sinatra/base'
require 'YAML'
require 'classes/users'

class ConfigServer < Sinatra::Base
  config = YAML::load_file(File.join(Dir.pwd, 'config', 'config.yml'))
  users = YAML::load_file(File.join(Dir.pwd, 'users', 'users.yml'))
  configure :production, :development do
    enable :logging
  end

  get '/' do
    request.env.each do |key, value|
      puts key

    end
    if request.env["HTTP_APIKEY"] != "d4c74594d841139328695756648b6bd6"
      halt 500
    end
    "Hello from MyApp!"
  end
  run!
end
#
