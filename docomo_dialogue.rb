require 'net/http'
require 'uri'
require 'json'

DOCOMO_DIALOGUE_URL = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue'
API_KEY = 'YOUR_API_KEY'

class Bot
  def initialize
    @utt = nil # ユーザの発話を指定(255文字以下)
    @context = nil # コンテキストIDを指定(255文字以下)
    # ※会話(しりとり)を継続する場合は、レスポンスボディのcontextの値を指定する
    @mode = nil # ※会話(しりとり)を継続する場合は、レスポンスボディのmodeの値を指定する
    @uri = URI.parse(DOCOMO_DIALOGUE_URL)
    @uri.query = 'APIKEY=' + API_KEY # クエリ文字列をつけている
  end

  # ユーザーの発話を受け取り、雑談対話APIの発話を返す
  def talk(utt)
    @utt = utt
    res = connect()
    @context ||= res['context']
    @mode = res['mode']
    res['utt']
  end

  private
  # 雑談対話APIとのやりとり
  def connect
    body = {}
    body[:utt] = @utt
    body[:context] = @context if @context
    body[:mode] = @mode if @mode
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(@uri.request_uri, {'Content-Type' => 'application/json'})
    req.body = body.to_json
    res = nil
    http.start do |h|
      temp_res = h.request(req)
      res = temp_res.body
    end
    JSON.parse(res)
  end
end
