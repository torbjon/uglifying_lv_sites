# encoding: utf-8
require 'uglifier'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require "net/https"
require "uri"

def get_js_sizes(title, url)
  rezult = "\n"
  rezult += "====" + title + "==================================== \n"
  @tvnet = Nokogiri::HTML(open(url), nil, 'UTF-8')
  js_count, total_max, total_min  = 0, 0, 0

  @tvnet.xpath("//script//@src").grep(/.js/).each do |x|  
    # add http to //mc.yandex like urls
    x = "http:" + x.to_s if x.to_s.start_with?("//")
    # add http://domain to /assets like urls
    x = url + x.to_s unless x.to_s.include? "http"

    if x.to_s.include? "https"
      uri = URI.parse(x)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      request = http.request(request).body
    else
      request = Net::HTTP.get(URI(x)).force_encoding('UTF-8')
    end

    str_ugly = Uglifier.compile(request.to_s, :toplevel => true, :unsafe => true)
    proc = (request.size.to_i-str_ugly.size.to_i).to_f/request.size.to_f
    
    js_count += 1
    total_max += request.size.to_i
    total_min += str_ugly.size.to_i
    # rezult += x.to_s + " | " + request.size.to_s + ", " + str_ugly.size.to_s + " > " + (proc*100.to_f).to_i.to_s + "%\n"
  end

  rezult += js_count.to_s + " js files\n"
  rezult += (total_max/1024).to_s + " Kb uncompressed size\n"
  rezult += (total_min/1024).to_s + " Kb compressed size\n"
  rezult += ((total_max - total_min)/1024).to_s + " Kb diff\n"
end

puts get_js_sizes("SS", "http://www.ss.lv")
puts get_js_sizes("TVNET", "http://www.tvnet.lv")
puts get_js_sizes("INBOX", "http://www.inbox.lv")
puts get_js_sizes("DELFI", "http://www.delfi.lv")
puts get_js_sizes("1188", "http://www.1188.lv")
puts get_js_sizes("APOLLO", "http://www.apollo.lv")
puts get_js_sizes("KASJAUNS", "http://www.kasjauns.lv")
puts get_js_sizes("DRAUGIEM", "http://www.draugiem.lv")
puts get_js_sizes("SPOKI", "http://www.spoki.lv")

