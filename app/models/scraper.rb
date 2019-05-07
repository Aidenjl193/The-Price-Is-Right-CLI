require 'net/http'
require 'pry'
require 'nokogiri'
require 'httparty'

class Scraper
  def self.get_page_count(cat)
    url = "https://www.argos.co.uk/search/#{cat}/?clickOrigin=searchbar:cat:term:#{cat}"
    doc = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(doc)
    parsed_page.css(".pagination__page-count").text.split(" of ")[1].to_i
  end
  
  def self.category(cat)
    page_count = get_page_count(cat)
    if(page_count == 0)
      return nil
    end
    return_arr = []
    #go to a random page
    for i in 0..9 do
      url = "https://www.argos.co.uk/search/#{cat}/opt/page:#{rand(page_count + 1)}/"
      return_arr << products_from_page(url).sample
    end
    return_arr
  end

  def self.products_from_page(url)
    doc = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(doc)
    parsed_page.css(".product-list").children.map do |product_card|
      {
        name: product_card.children[1]["aria-label"],
        price: product_card.children[1].css(".ac-product-price__amount").text[1..-1].to_i
      }
    end
  end
end
