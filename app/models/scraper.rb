require 'net/http'
require 'pry'
require 'nokogiri'
require 'httparty'

class Scraper
  def self.category(cat)
    url = "https://www.argos.co.uk/search/#{cat}/?clickOrigin=searchbar:cat:term:#{cat}"
    doc = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(doc)
    parsed_page.css(".product-list").children.each do |product_card|
      puts product_card.children[1]["aria-label"]
      puts product_card.children[1].css(".ac-product-price__amount").text
    end
    ""
  end
end
