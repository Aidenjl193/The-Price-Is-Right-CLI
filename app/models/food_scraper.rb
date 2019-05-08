require 'nokogiri'
require 'httparty'

class FoodScraper
  def self.get_info(string)
    url_string = string.split(" ").join("%20")
    url = "https://www.nutritionix.com/natural-demo?q=#{url_string}"
    doc = HTTParty.get(url)
    puts doc
    parsed_page = Nokogiri::HTML(doc)
    parsed_page.css(".ng-scope").each do |food_html|
      puts food_html
    end
  end
end
