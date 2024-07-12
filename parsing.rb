require "nokogiri"
require 'open-uri'
file = "fraise.html"
doc = Nokogiri::HTML.parse(File.open(file), nil, "utf-8")

temp_recipes = []
doc.search(".recipe-card-link").first(5).each do |element|
  name = element.search(".recipe-card__title").text.strip
  url = element["href"]
  rating = element.search(".mrtn-home-rating__rating").text.strip
  # url = 'https://www.marmiton.org/recettes/recette_the-tarte-aux-fraises_22726.aspx'
  html_recipe = Nokogiri::HTML.parse(URI.parse(url).read)
  description = ''
  html_recipe.search(".recipe-step-list .recipe-step-list__container").each do |element|
    description << "#{element.search('span').text.strip} \n"
    description << "#{element.search('p').text.strip} \n"
  end
  temp_recipes << Recipe.new(name, description, rating)
end
puts description
