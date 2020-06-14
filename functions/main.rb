require 'net/https'
require 'net/http'
require 'uri'
require 'json'
require 'slack-notifier'

def zoom
  # credentials情報から取得
  api_key = 'aaaaaaa'
  secret  = 'bbbbbbb'
  user_id = 'ccccccc'
  jwt = 'ddddddd'
  meeting_url = "https://api.zoom.us/v2/users/#{user_id}/meetings"

  uri = URI.parse(meeting_url)
  http = Net::HTTP.new(uri.host, uri.port)

  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  req = Net::HTTP::Post.new(uri.path)
  req['Authorization'] = "Bearer #{jwt}"
  req['Content-Type'] = 'application/json'
  req.body = { 'type': 1 }.to_json
  res = http.request(req)
  # response
  puts res.body

  # zoomミーティングのURLのみ取得
  parseURL = JSON.parse(res.body)
  body = parseURL['join_url']

  slack_notification(body)
end

def slack_notification(body)
  notifier = Slack::Notifier.new('https://hooks.slack.com/services/xxxxxxx')
  text = "ミーティングを作成しました！\n#{body}"
  notifier.ping text
end

zoom