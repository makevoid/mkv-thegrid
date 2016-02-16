# require 'bundler'
# Bundler.require :default
require 'dnsimple'

path = File.expand_path "../../", __FILE__
PATH = path


read_api_token = -> {
  token = File.read "#{PATH}/config/dnsimple_token.txt"
  token.strip
}

USERNAME = "makevoid@gmail.com"
API_TOKEN = read_api_token.()

DOMAIN = "mkvd.net" # TODO

DNS = Dnsimple::Client.new username: USERNAME, api_token: API_TOKEN


records = DNS.domains.records DOMAIN

p records

puts "Records:"
records.each do |r|
  name = r.name
  name = "\t" if name == ""
  puts "\t#{r.type} - #{name}\t=> #{r.content}"
  # puts "\tRecord: #{record.name}"
end
puts "\tNo records" if records.empty?
puts ""

# SERVERS = {}
eval File.read "#{PATH}/config/servers.rb" # TODO: use json

RECORDS = {}

SERVERS.each do |name, ip|
  RECORDS[name]        = ip
  RECORDS["*.#{name}"] = ip
end

RECORDS.each do |name, ip|
  # DNS.domains.create_record DOMAIN, record_type: "A", name: name, content: ip
  puts "Record: #{name}.#{DOMAIN}\t=> #{ip} - created!"
end
