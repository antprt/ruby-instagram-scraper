require 'open-uri'
require 'json'

module RubyInstagramScraper

  BASE_URL = "https://www.instagram.com"

    BASE_URL = "https://www.instagram.com"

  def self.search ( query )
    # return false unless query
    url = "#{BASE_URL}/web/search/topsearch/"
    params = "?query=#{query}"

    JSON.parse open("#{url}#{params}").read
  end

  def self.get_user_media_nodes(username, max_id = nil)
    get_user(username, max_id)['media']['nodes']
  end

  def self.get_user(username, max_id = nil)
    url = "#{BASE_URL}/#{username}/?__a=1"
    url += "&max_id=#{max_id}" if max_id

    JSON.parse(open(url).read)["graphql"]["user"]
  end

  def self.get_tag_media_nodes(tag, max_id = nil)
    url = "#{BASE_URL}/explore/tags/#{tag}/?__a=1"
    url += "&max_id=#{max_id}" if max_id

    JSON.parse(open(url).read)['tag']['media']['nodes']
  end

  def self.get_media(code)
    url = "#{BASE_URL}/p/#{code}/?__a=1"

    JSON.parse(open(url).read)['graphql']['shortcode_media']
  end

  def self.get_user_info ( username, max_id = nil )
    url = "#{BASE_URL}/#{ username }/?__a=1"
    params = ""
    params = "&max_id=#{ max_id }" if max_id
    begin
      user = JSON.parse( open( "#{url}#{params}" ).read )["graphql"]["user"]
      post1 = { :code => user["edge_owner_to_timeline_media"]["edges"].first["node"]["shortcode"], :image => user["edge_owner_to_timeline_media"]["edges"].first["node"]["thumbnail_resources"].third["src"], :caption => user["edge_owner_to_timeline_media"]["edges"].first["node"]["edge_media_to_caption"]["edges"].first["node"]["text"], :comments => user["edge_owner_to_timeline_media"]["edges"].first["node"]["edge_media_to_comment"]["count"], :likes => user["edge_owner_to_timeline_media"]["edges"].first["node"]["edge_liked_by"]["count"]}
      post2 = { :code => user["edge_owner_to_timeline_media"]["edges"].second["node"]["shortcode"], :image => user["edge_owner_to_timeline_media"]["edges"].second["node"]["thumbnail_resources"].third["src"], :caption => user["edge_owner_to_timeline_media"]["edges"].second["node"]["edge_media_to_caption"]["edges"].first["node"]["text"], :comments => user["edge_owner_to_timeline_media"]["edges"].second["node"]["edge_media_to_comment"]["count"], :likes => user["edge_owner_to_timeline_media"]["edges"].second["node"]["edge_liked_by"]["count"]}
      post3 = { :code => user["edge_owner_to_timeline_media"]["edges"].third["node"]["shortcode"], :image => user["edge_owner_to_timeline_media"]["edges"].third["node"]["thumbnail_resources"].third["src"], :caption => user["edge_owner_to_timeline_media"]["edges"].third["node"]["edge_media_to_caption"]["edges"].first["node"]["text"], :comments => user["edge_owner_to_timeline_media"]["edges"].third["node"]["edge_media_to_comment"]["count"], :likes => user["edge_owner_to_timeline_media"]["edges"].third["node"]["edge_liked_by"]["count"]}

      return { :subscribers => user["edge_followed_by"]["count"], :post1 => post1, :post2 => post2, :post3 => post3 }
    rescue
      return nil
    end
  end
  
end