require 'net/https'
require 'time'
require 'api-auth'
require 'json'

URL = 'https://anish-support.mingle-api.thoughtworks.com/api/v2/projects/house_build/cards/1.xml'
OPTIONS = {:access_key_id => 'anishn', :access_secret_key => 'U0VOB8gw0UQYwF4zjyxtqnCXmFJXm70itEfIwP/Odgo='}

def http_get(url, options={})
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  
  ApiAuth.sign!(request, options[:access_key_id], options[:access_secret_key])

  response = http.request(request)
  cards = response.body

  if response.code.to_i > 300
    raise StandardError, <<-ERROR
    Request URL: #{url}
    Response: #{response.code}
    Response Message: #{response.message}
    Response Headers: #{response.to_hash.inspect}
    Response Body: #{response.body}
    ERROR
  end

  cards
end

puts http_get(URL, OPTIONS)
