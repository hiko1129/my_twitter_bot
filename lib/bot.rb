# frozen_string_literal: true
require 'twitter'
require 'docomoru'

docomoru_client = Docomoru::Client.new(api_key: ENV['DOCOMO_API_KEY'])

CONSUMER_KEY = ENV['TWITTER_API_KEY']
CONSUMER_SECRET = ENV['TWITTER_API_SECRET']
ACCESS_TOKEN = ENV['TWITTER_ACCESS_TOKEN']
ACCESS_TOKEN_SECRET = ENV['TWITTER_ACCESS_TOKEN_SECRET']
MY_USERNAME = ENV['TWITTER_USERNAME']

rest_client = Twitter::REST::Client.new do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.access_token = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

stream_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.access_token = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

stream_client.user do |object|
  if object.is_a?(Twitter::Tweet)
    username = object.user.screen_name
    tweet = object.text
    tweet_id = object.id
    # 自分のツイートでない場合、Botがリプライする
    if username != MY_USERNAME
      response = docomoru_client.create_dialogue(tweet)
      rest_client.update("@#{username} #{response.body['utt']}",
                         in_reply_to_status_id: tweet_id)
    end
  end
end
