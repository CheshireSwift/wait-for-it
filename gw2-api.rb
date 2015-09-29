module GuildWars
  require 'net/https'
  require 'uri'
  require 'json'
  require 'rack'

  BASE_URI = 'https://api.guildwars2.com/v2/'
  API_KEY = 'F5449F30-8B39-BB4E-9318-FCB0097BE9069B982DB5-5C6B-47A6-ADD5-55F354442BDB'

  class Price < Struct.new(:low, :high)
    def +(price)
      Price.new(self.low + price.low, self.high + price.high)
    end

    def *(num)
      Price.new(self.low * num, self.high * num)
    end

    def to_s
      "#{pretty_print self.low} - #{pretty_print self.high}"
    end
  end

  def GuildWars.get(path, query_hash)
    query_string = query_hash ? '?' + Rack::Utils.build_query(query_hash) : ''
    uri = URI::join(BASE_URI, path) + query_string
    puts uri
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  def GuildWars.get_value(item_id)
    if !item_id then
      puts "Missing entry."
      return 0
    end

    results = get("commerce/prices/#{item_id}")
    #puts results
    Price.new(results["buys"]["unit_price"], results["sells"]["unit_price"])
  end

  def GuildWars.pretty_print(total_copper)
    copper = total_copper % 100
    silver = (total_copper / 100) % 100
    gold = total_copper / (100 * 100)
    "#{gold}g #{silver}s #{copper}c"
  end

  def GuildWars.debug
    get('tokeninfo', {:access_token => API_KEY})
  end
end

