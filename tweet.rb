require_relative 'docomo_dialogue'
require 'twitter'

CONSUMER_KEY = 'YOUR_CONSUMER_KEY'
CONSUMER_SECRET = 'YOUR_CONSUMER_SECRET'
ACCESS_TOKEN = 'YOUR_ACCESS_TOKEN'
ACCESS_TOKEN_SECRET = 'YOUR_ACCESS_TOKEN_SECRET'
MY_USERNAME = 'YOUR_TWITTER_USERNAME'

bot = Bot.new

client_rest = Twitter::REST::Client.new do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.access_token = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

client_stream = Twitter::Streaming::Client.new do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.access_token = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end


client_stream.user do |object|
  if object.is_a?(Twitter::Tweet)
    username = object.user.screen_name
    tweet = object.text
    tweet_id = object.id
    # 自分のツイートでない場合、Botがリプライする
    if username != MY_USERNAME
      client_rest.update("@#{username} #{bot.talk(tweet)}", { in_reply_to_status_id: tweet_id })
    end
    # ダイレクトメッセージにも対応させるかも
  end
end
