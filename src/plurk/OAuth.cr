require "http/client"
require "oauth"

module Plurk
  class OAuth
    getter consumer_key : String
    getter consumer_secret : String
    getter oauth_callback : String
    getter consumer : ::OAuth::Consumer
    property token : String
    property secret : String

    def initialize(@consumer_key, @consumer_secret, @oauth_callback = "", token = nil, secret = nil)
      @consumer = ::OAuth::Consumer.new("www.plurk.com",
                                      consumer_key,
                                      consumer_secret,
                                      request_token_uri: "/OAuth/request_token",
                                      access_token_uri: "/OAuth/access_token",
                                      authorize_uri: "/OAuth/authorize")
      request_token = @consumer.get_request_token(@oauth_callback)
      @token  = token  || request_token.token
      @secret = secret || request_token.secret
    end

    def get_authorize_url
      @consumer.get_authorize_uri(request_token, @oauth_callback)
    end

    def get_access_token(oauth_verifier : String)
      access_token = @consumer.get_access_token(request_token, oauth_verifier)
      @token, @secret = [access_token.token, access_token.secret]
      access_token
    end

    def authenticate(path : String)
      client = HTTP::Client.new("www.plurk.com", tls: true)
      access_token.authenticate(client, consumer_key, consumer_secret)
      client.get path
    end

    private def request_token
      ::OAuth::RequestToken.new(@token, @secret)
    end

    private def access_token
      ::OAuth::AccessToken.new(@token, @secret)
    end
  end
end
