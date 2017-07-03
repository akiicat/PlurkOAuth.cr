[![Build Status](https://travis-ci.org/akiicat/PlurkOAuth.cr.svg?branch=master)](https://travis-ci.org/akiicat/PlurkOAuth.cr)

# PlurkOAuth.cr

A crystal library for [Plurk OAuth API](https://www.plurk.com/API)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  plurk-oauth:
    github: akiicat/PlurkOAuth.cr
    branch: master
```

## Usage

In your crystal project

```crystal
require "plurk-oauth"
```

config env setting

```sh
# terminal
export CONSUMER_KEY="<your_consumer_key>"
export CONSUMER_SECRET="<your_consumer_secret>"
export OAUTH_CALLBACK="<your_oauth_callback>" # leave empty string if not have callback url
```

### Application

```crystal
require "json"
require "plurk-oauth"

consumer_key    = ENV["CONSUMER_KEY"]
consumer_secret = ENV["CONSUMER_SECRET"]
oauth_callback  = ENV["OAUTH_CALLBACK"]

plurk = Plurk::OAuth.new(consumer_key, consumer_secret, oauth_callback)
puts "auth url: #{plurk.get_authorize_url}"

# Go to auth url get oauth verifier

print "oauth verifier: "
access_token = plurk.get_access_token(gets.to_s.chomp)

response = plurk.authenticate("/APP/Users/me")
p JSON.parse(response.body)
```

console output

```
auth url: https://www.plurk.com/OAuth/authorize?oauth_token=xxxxxxxxxxxx&oauth_callback=
oauth verifier: 123456
{"verified_account" => false, ...}
```

### Web Application

You need to redirect the `oauth_callback` to `def callback` methods

```crystal
def auth
  consumer_key    = ENV["CONSUMER_KEY"]
  consumer_secret = ENV["CONSUMER_SECRET"]
  oauth_callback  = ENV["OAUTH_CALLBACK"]

  plurk = Plurk.new(consumer_key, consumer_secret, oauth_callback)

  # save the temporary token
  session["token"]  = plurk.token
  session["secret"] = plurk.secret

  auth_url = plurk.get_authorize_url

  # render page and give auth url to user
end
```

```crystal
def callback
  consumer_key    = ENV["CONSUMER_KEY"]
  consumer_secret = ENV["CONSUMER_SECRET"]
  oauth_callback  = ENV["OAUTH_CALLBACK"]

  plurk = Plurk.new(consumer_key, consumer_secret, oauth_callback, session["token"], session["secret"])
  plurk.get_access_token(params["oauth_verifier"])

  # use the authenticated token for the next time
  session["token"]  = plurk.token
  session["secret"] = plurk.secret

  # now you can use authenticate to get user data
  response = plurk.authenticate("/APP/Users/me")

  # and convert to hash:
  JSON.parse(response.body)
end
```

## Contributing

1. Fork it ( https://github.com/akiicat/plurk/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
