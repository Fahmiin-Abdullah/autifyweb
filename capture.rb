require 'date'
require 'net/http'
require 'nokogiri'
require 'optparse'

class Autifyweb
  def initialize(url)
    @url = url
  end

  def parse
    check_url

    dir = generate_dir_name
    Dir.mkdir(dir) if (! File.exist? dir)
    source = Net::HTTP.get(@url)
    contents = Nokogiri::HTML(source)

    html_path = File.join(dir, File.basename(@url.to_s))
    html_path += '.html' if html_path !~ /\.((html?)|(txt))$/
    meta_path = File.join(dir, 'metadata')

    File.open(html_path, 'w') { |f| f.write(contents.to_html) }
    File.open(meta_path, 'w') { |f| f.write(fetch_metadata(contents)) }
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

  def generate_dir_name
    host = @url.host.downcase
    host = host[4..-1] if host.start_with?('www.')
    host.split('.')[0]
  end

  def fetch_metadata(contents)
    links_count = contents.xpath('//a[@href]').count
    images_count = contents.xpath('//img[@src]').count

    "#{$/}Site name: #{@url}#{$/}Number of links: #{links_count}#{$/}Number of images: #{images_count}#{$/}Last fetched: #{DateTime.now.strftime('%m/%d/%Y %I:%M %p')}"
  end

  def print_metadata(dir)
    puts File.read(File.join(dir, 'metadata'))
  rescue Errno::ENOENT
    $stderr.puts "The folder for #{dir} could not be found!"
    exit 1
  end
end

OptionParser.new do |parser|
  parser.banner = "Usage: capture.rb [flag] [url_1] [url_2]"

  parser.on("-m", "--metadata", "Print out the metadatas of saved webpages") do
    @metadata_flag = true
  end

  parser.on("-h", "--help", "Show this help message") do
    @help_open = true
    puts parser
  end
end.parse!

if __FILE__ == $0 && !@help_open
  if ARGV.count < 1
    $stderr.puts 'Please enter at least 1 URL link or directory name'
    exit 1
  end

  ARGV.each do |arg|
    doc = Autifyweb.new(URI.parse(arg))

    if @metadata_flag
      doc.print_metadata(arg)
    else
      doc.parse
    end
  end

  puts 'Process completed!'
end
