require 'em-synchrony/em-http'

module Goliath
  module Rack
    class ReverseProxy
      include Goliath::Rack::AsyncMiddleware

      attr_reader :options

      def initialize(app, options)
        @app = app
        @options = options
      end

      def post_process(env, status, headers, body)
        method = env['REQUEST_METHOD'].downcase.to_sym

        url = "#{@options[:base_url]}#{env['REQUEST_URI']}"

        env.each do |key, value|
          headers[$1] = value if key =~ /HTTP_(.*)/
        end
        headers['HTTP_HOST'] = env['SERVER_NAME']
        headers['X-Forwarded-Host'] = env['HTTP_HOST']

        params = {head: headers}
        params[:body] = env['params'] if [:put, :post, :patch].include? method
  
        http = EM::HttpRequest.new(url).send(method, params)

        [http.response_header.status, http.response_header, [http.response]]
      end

    end

  end
end
