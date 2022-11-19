require 'net/http'
require 'nokogiri'

class Autifyweb
  def initialize(uri)
    @uri = uri
  end

  def parse
    source = Net::HTTP.get(@uri)
    contents = Nokogiri::HTML(source)
    path = File.basename(@uri.to_s)
    path += '.html' if path !~ /\.((html?)|(txt))$/

    File.open(path, 'w') { |f| f.write(contents.to_html) }
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
