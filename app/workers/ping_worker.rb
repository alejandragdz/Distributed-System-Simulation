require 'net/http'
class PingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :ping
  def perform(*args)
    # uri = URI.parse("https://xxxxx.herokuapp.com/xxxxx")
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # http.get(uri.request_uri)
    puts "wsdclvjldfnksñ,knv_____________________"
  end
end