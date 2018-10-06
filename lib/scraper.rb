require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = Nokogiri::HTML(open(index_url)).css(".student-card")
    students.map do |student|
      url = student.css("a").attribute("href").text
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      {name: name, location: location, profile_url: url}
    end
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    urls = profile.css(".social-icon-container a")
    info = {}
    urls.each do |url|
      href = url.attribute("href").text
      icon = url.css("img").attribute("src").text
      if !icon.nil?
        media = File.basename(icon).gsub(".png","")
        media.gsub!("-icon","")
        media.gsub!(/(rss|facebook)/,"blog")
        info[media.to_sym] = href
      end
    end
    info.merge!(
      {
        :profile_quote => profile.css(".profile-quote").text,
        :bio => profile.css(".description-holder p").text
      }
    )
  end

end
