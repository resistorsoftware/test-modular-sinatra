require 'bundler/setup'
Bundler.require(:default)

Warden::Manager.serialize_into_session{|user| user.id }
Warden::Manager.serialize_from_session{|id| User.get(id) }

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = "POST"
end

Warden::Strategies.add(:password) do
  def valid?
    params["email"] || params["password"]
  end

  def authenticate!
    if params["email"] == 'foo@baz.com' && params["password"] == '1234'
      u = User.new("Poobah Public")
    end
    u.nil? ? fail!("Could not log in") : success!(u)
  end
end

Warden::Strategies.add(:admin) do
  def valid?
    params["email"] || params["password"]
  end

  def authenticate!
    if params["email"] == 'admin@baz.com' && params["password"] == '1234!'
      u = User.new("Poobah Admin")
    end
    u.nil? ? fail!("Could not log in") : success!(u)
  end
end
  
require File.dirname(__FILE__) + "/main.rb"

map '/' do
  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = Poobah::Public
  end
  run Poobah::Public
end

map '/admin' do
  use Warden::Manager do |manager|
    manager.default_strategies :admin
    manager.failure_app = Poobah::Admin
  end
  run Poobah::Admin
end

map '/special' do
  run Poobah::Special
end


