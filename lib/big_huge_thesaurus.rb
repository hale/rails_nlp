module BigHugeThesaurus
  require 'json'
  require 'httparty'

  def self.synonyms word
    if not ENV['BHT_API_KEY']
      raise Exception.new "You must set a value for 'BHT_API_KEY' in .env, and run with foreman."
    end
    api_key = ENV['BHT_API_KEY']
    response = HTTParty.get "http://words.bighugelabs.com/api/2/#{api_key}/#{word}/json"
    return [] if response.nil?
    json = JSON.parse( response.to_json )
    synonyms = []
    json.values.count.times do |n|
      (synonyms << json.values[n]['syn'].flatten) if json.values[n]['syn']
    end
    return [] if ( response.nil? or synonyms.empty? )
    synonyms.flatten.uniq
  end
end
