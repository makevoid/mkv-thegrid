require 'net/http'
require 'json'
require 'hashie/mash'
MH = Hashie::Mash unless defined? MH

def url(name) # collection name (pinterest)
  "https://api.pinterest.com/v1/boards/#{USER}/#{name}/pins/?access_token=#{ACCESS_TOKEN}&fields=url%2Coriginal_link%2Cnote" # %2Cnote%2Curl%2Cid (note, url, url and id fields are available)
end

def get_pins(name)
  pins = []
  resp = Net::HTTP.get_response URI url name
  json = JSON.parse resp.body
  pins = json["data"]
  p pins
  pins.map do |pin|
    MH.new pin
  end
end

# step 1 of this script, simplest example:
#
# url "bitcoinblockchain", should return an url that you can get (Net::HTTP.get_response + JSON.parse(resp.body)) to get the pin urls (link field)

USER = "Coolchicliving"

ACCESS_TOKEN = "AbJWOzi58Ltzjzo4HT2u2MykYjFuFDPcZqnMDClCj9T5zEAOrwAAAAA"

NAMES = %w(bitcoinblockchain technology sky innovation 3d-printing skyscrapers blocks)

urls = []
for name in NAMES
  pins = get_pins name
  for pin in pins
    url = "#{pin.original_link}##{pin.note}"
    urls << url
  end
end

# this should be "returned" by the eval
URLS = urls
