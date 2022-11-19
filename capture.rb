require 'net/http'
require 'nokogiri'

class Autifyweb
  def initialize(url)
    @url = url
  end

  def parse
    check_url

    source = Net::HTTP.get(@url)
    contents = Nokogiri::HTML(source)
    path = File.basename(@url.to_s)
    path += '.html' if path !~ /\.((html?)|(txt))$/

    File.open(path, 'w') { |f| f.write(contents.to_html) }
  end

  def check_url
    response = Net::HTTP.get_response(@url)
    if response.code.to_i >= 400
      $stderr.puts "Process exited with ERROR #{response.code}: #{@url}"
      return
    end

    if %w[301 302 307].include?(response.code)
      @url = URI.parse(response['location'])
    end
  end
end

if __FILE__ == $0
  if ARGV.count < 1
    $stderr.puts "Please enter at least 1 URL link"
    exit 1
  end

  ARGV.each do |arg|
    doc = Autifyweb.new(URI.parse(arg))
    doc.parse
  end
end
