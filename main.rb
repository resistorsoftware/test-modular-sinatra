# Modular App Test with Sinatra-Warden

module Poobah
  
  class User
    attr_accessor :name
    def initialize(name) 
      @name = name
    end
  end
   
  class Public < Sinatra::Base
    register Sinatra::Warden 
    set :run, false 
     
    get '/' do
      authorize!('/login')
      haml :index
    end
    
    get '/login' do
      haml :login
    end
    
    post '/login' do
      authenticate
      redirect('/')
    end
    
  end
   
  class Admin < Sinatra::Base
    get '/' do
      haml :'admin/index'
    end
  end
   
  class Special < Sinatra::Base
    get '/' do
      haml :'special/index'
    end
  end
   
end