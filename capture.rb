require 'net/http'
require 'nokogiri'
require 'optparse'

class Autifyweb
  def initialize(url, with_metadata = false)
    @url = url
    @with_metadata = with_metadata
  end

  def parse
    check_url

    source = Net::HTTP.get(@url)
    contents = Nokogiri::HTML(source)
    path = File.basename(@url.to_s)
    path += '.html' if path !~ /\.((html?)|(txt))$/

    File.open(path, 'w') { |f| f.write(contents.to_html) }
    return unless @with_metadata

    print_metadata(contents)
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

  def print_metadata(contents)
    links_count = contents.xpath('//a[@href]').count

    p "Number of links: #{links_count}"
  end
end

OptionParser.new do |parser|
  parser.banner = "Usage: capture.rb [options]"

  parser.on("-m", "--metadata", "Fetch the metadata") do
    @metadata_flag = true
  end

  parser.on("-h", "--help", "Show this help message") do
    puts parser
  end
end.parse!

if __FILE__ == $0
  if ARGV.count < 1
    $stderr.puts 'Please enter at least 1 URL link'
    exit 1
  end

  ARGV.each do |arg|
    doc = Autifyweb.new(URI.parse(arg), @metadata_flag)
    doc.parse
  end

  puts 'Process completed!'
end
