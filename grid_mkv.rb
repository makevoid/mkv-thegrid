require 'hashie'
MH = Hashie::Mash
require_relative 'lib/saf'

TOKEN = "0yuYKLWb0NSyjJF7RzSEEWaslpqydzwQcdO4vjaDyTQQHzZzjoxYoXxqDHcjJrrLg70JopkK" # run THEGRID_APP_ID=your_uuid THEGRID_APP_SECRET=xxxxx coffee publish/auth.coffee
# then visit localhost:3000 to obtain the token


def site_path(name)
  "config/site-#{name}.saf"
end

def share(url)
  `THEGRID_TOKEN=#{TOKEN} coffee publish/share-url.coffee #{url}`
end

# name = :mkv
name = :blockchain
site = Saf.load site_path(name)
site = MH.new site.first
urls = site.log.split "\n"

urls.each_with_index do |url, idx|
  puts "sharing url: #{url}"

  share url
end
