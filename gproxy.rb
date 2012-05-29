require 'rack/session/cookie'
require 'goliath'
require 'goliath/rack/auth/krb/basic_and_nego'
require 'goliath/rack/reverse_proxy'

class Gproxy < Goliath::API
  use Rack::Session::Cookie, key: 'gproxy.session'
  use Goliath::Rack::Auth::Krb::BasicAndNego, ENV['REALM'], ENV['KEYTAB'], ENV['SERVICE']
  use Goliath::Rack::Params
  use Goliath::Rack::ReverseProxy, base_url: ENV['BASE_URL']

  def response(env)
    [200, {}, []]
  end

end
