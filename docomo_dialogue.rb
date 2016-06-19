require 'net/http'
require 'uri'
require 'json'

DOCOMO_DIALOGUE_URL = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue'
API_KEY = 'YOUR_API_KEY'

class Bot
  def initialize
    @utt = nil
    @context = nil
    @mode = nil
    @uri = URI.parse(DOCOMO_DIALOGUE_URL)
    @uri.query = 'APIKEY=' + API_KEY
  end

  def talk(utt)
    @utt = utt
    res = connect()
    @context ||= res['context']
    @mode = res['mode']
    res['utt']
  end

  private
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
