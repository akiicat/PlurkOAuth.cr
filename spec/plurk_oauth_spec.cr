require "./spec_helper"

describe Plurk::OAuth do
  it "has env key" do
    [
      ENV["CONSUMER_KEY"],
      ENV["CONSUMER_SECRET"],
      ENV["OAUTH_CALLBACK"]
    ].each do |env|
      env.should be_a String
    end
  end

  describe "#initialize" do
    it "has token and secret" do
      consumer_key    = ENV["CONSUMER_KEY"]
      consumer_secret = ENV["CONSUMER_SECRET"]
      oauth_callback  = ENV["OAUTH_CALLBACK"]

      plurk = Plurk::OAuth.new(consumer_key, consumer_secret, oauth_callback)
      plurk.token.should be_a String
      plurk.secret.should be_a String
    end

    it "can pass token and secret" do
      consumer_key    = ENV["CONSUMER_KEY"]
      consumer_secret = ENV["CONSUMER_SECRET"]
      oauth_callback  = ENV["OAUTH_CALLBACK"]

      plurk = Plurk::OAuth.new(consumer_key, consumer_secret, oauth_callback, "token", "secret")
      plurk.token.should be "token"
      plurk.secret.should be "secret"
    end
  end

  describe "#get_authorize_url" do
    it "return url" do
      consumer_key    = ENV["CONSUMER_KEY"]
      consumer_secret = ENV["CONSUMER_SECRET"]
      oauth_callback  = ENV["OAUTH_CALLBACK"]

      plurk = Plurk::OAuth.new(consumer_key, consumer_secret, oauth_callback)
      plurk.get_authorize_url.should contain "https"
    end
  end

  describe "#get_access_token" do
    pending "need user auth" do end
  end

  describe "#authenticate" do
    pending "need user auth" do end
  end
end
