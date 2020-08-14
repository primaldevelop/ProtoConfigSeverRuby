require 'sinatra/base'
require 'YAML'
require './classes/users'

class ConfigServer < Sinatra::Base
  use_auth = false
  config = YAML::load_file(File.join(Dir.pwd, 'config', 'config.yml'))
  users = YAML::load_file(File.join(Dir.pwd, 'config', 'users.yml'))
  configure :production, :development do
    enable :logging
  end

  config[:settings].each do |settings, value|
    use_auth = value["use_auth"]
  end

  usersbase = Users.new
  users[:users].each do |user, details|
    usersbase.add_user(User.new(user, details[:token]))
  end


  get '/' do
    # Сделать проверку наличия у пользователя прав на приложение настройки которого он запрашивает
    # Выводить нормальные статусы при ошибке
    req_token = request.env["HTTP_APIKEY"]
    user = usersbase.find_by_token(req_token)
    if use_auth then #Проверка на то включена ли вообще аутентификация

      # if req_token == nil then #Проверка на наличие токена в хедере запроса
      # halt 403
      #   body "No Token"
      # end
      halt 403, 'missing api token' unless req_token.nil?


      if user.instance_of? User then #Проверка на то что токен есть пользователя и если есть метод вернет объект User
        "Hello from MyApp!"
      else
        halt 500
     end
      else
      "Hello from MyApp! no auth"
    end
  end
  run!
end

