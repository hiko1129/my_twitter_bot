require_relative 'docomo_dialogue'
require 'twitter'

CONSUMER_KEY = 'YOUR_CONSUMER_KEY'
CONSUMER_SECRET = 'YOUR_CONSUMER_SECRET'
ACCESS_TOKEN = 'YOUR_ACCESS_TOKEN'
ACCESS_TOKEN_SECRET = 'YOUR_ACCESS_TOKEN_SECRET'

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
    # TO DO 自分のツイートでなければリプライする（screen_nameを使用すればよいかは不明、試し）
    if object.user.screen_name != 'YOUR_SCREEN_NAME'
      client_rest.update("@#{object.user.screen_name} #{bot.talk(object.text)}", options = { in_reply_to_status_id: object.id })
    end
    # ダイレクトメッセージにも対応させるかも
  end
end


# test
puts 'input your tweet'
input = gets.chomp
client_rest.update(input)
