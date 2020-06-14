require 'net/https'
require 'net/http'
require 'uri'
require 'json'
require 'slack-notifier'

def zoom
  # ZoomAPIリクエスト情報を作成
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

  # ZoomAPI実行
  res = http.request(req)
  puts res.body

  # レスポンスからzoomミーティングのURLを取得
  parseURL = JSON.parse(res.body)
  body = parseURL['join_url']

  # Slack通知
  slack_notification(body)
end

def slack_notification(body)
  slack_webhook = 'https://hooks.slack.com/services/xxxxxxx'
  notifier = Slack::Notifier.new(slack_webhook)
  text = "ミーティングを作成しました！\n#{body}"
  notifier.ping text
end

zoom