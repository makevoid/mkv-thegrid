require 'hashie'
MH = Hashie::Mash
require_relative 'lib/saf'
PATH = File.expand_path "../", __FILE__

MESSAGES = {
  usage: "antani"
}
USG = MESSAGES[:usage]

CMD = ARGV[0] # $1

def token_env?
  ENV["TOKEN"]
end

TOKEN = if token_env?
  TOKEN = ENV["TOKEN"]
else
  "0yuYKLWb0NSyjJF7RzSEEWaslpqydzwQcdO4vjaDyTQQHzZzjoxYoXxqDHcjJrrLg70JopkK" # run THEGRID_APP_ID=your_uuid THEGRID_APP_SECRET=xxxxx coffee publish/auth.coffee
  # then visit localhost:3000 to obtain the token
end

def site_path(name)
  "config/site-#{name}.saf"
end

def share(url)
  puts `THEGRID_TOKEN=#{TOKEN} coffee publish/share-url.coffee #{url}`
end

def upload(path)
  `THEGRID_TOKEN=#{TOKEN} coffee publish/share-file.coffee #{path}`
end

def share_all(name)
  site = Saf.load site_path(name)
  site = MH.new site.first
  urls = site.log.split "\n"

  urls.each_with_index do |url, idx|
    puts "sharing url: #{url}"

    share url
  end
end

def share_pinterest_all
  # evil :D
  urls = eval File.read "#{PATH}/config/site-sky.rb"
  urls = URLS if defined? URLS

  urls.each_with_index do |url, idx|
    puts "sharing url: #{url}"

    share url
  end
end

def upload_all
  photos = Dir.glob("photos/to_upload/*")
  photos.each do |photo|
    puts "uploading #{photo}"
    upload photo
  end
end


require_relative 'redis-aof'
def dynamic_matches()
  R.connect if not R.connected # this will block, spawn a redis server (that logs in db/main.rdb) and waits to be connected, AOF strategy, can be replaced by a AOF database/program/script
  current_matches = R.matches
  current_matches # easy as that
end

def share_all_nu(name)
  cont = File.read "#{PATH}/config/#{name}"

  urls = cont.split "\n"
  urls.compact!
  urls.reject!{ |u| u == "" }
  urls = urls.map do |url|
    url.match(/(.+?) /)[1]
  end

  raise urls.inspect
  urls = site.log.split "\n"

  urls.each_with_index do |url, idx|
    puts "sharing url: #{url}"

    share url
  end
end

# MAIN :D

def main
  share_all_nu "content-youtube.saf"
  return
  # share_pinterest_all


  case CMD
  when /up|upload/
    upload_all
  when /url|link|links|share/
    share_saf_all
  when /bla/
    puts "bla"
  when /antani/
    puts "come se fosse antanizer"
  when dynamic_matches
    puts "dynamic match!!! Diane, che comando vuoi dare? e me lo salvo non ti preoccupare, bellino! (that translated is something like:) Diaaa-ane! What command do you want to tell to me (Program, but you can call me via the 'name' command)? input(:command_name, &user_antani) # this command blocks, waits for the user input;  `grid antani wait`; # wait called, running with user input on (sync); # antani is not defined, plesea define command for antani function; `curl antani.com && deantanize` # ok command antani registered; # you can call how the new registered function via `grid antani [arguments]`" # redis will load the commands in memory from disk
  else
    puts "NOT FOUND"
  end
end

# MAIN!  :D
#
main()
