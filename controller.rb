require_relative 'view'
require_relative 'recipe'
require "nokogiri"
require 'open-uri'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    # get all recipes
    list = @cookbook.all
    # display them all
    @view.display_list(list)
  end

  def add
    # get name and description of recipe
    name = @view.ask_recipe_name
    description = @view.ask_recipe_description
    rating = @view.ask_recipe_rating
    # create recipe
    recipe = Recipe.new(name, description, rating)
    # add to cookbook
    @cookbook.create(recipe)
    list
  end

  def remove
    list
    # get name and description of recipe
    index = @view.ask_recipe_index
    # delete recipe
    @cookbook.destroy(index)
    list
  end

  ## note : ici je crée les 5 instances Recipe et je cherche directement les descriptions.
  ## une version plus light consisterait à lister seulement les noms et les ratings obtenus depuis la page de résultats,
  ## puis de parser uniquement la page du résultat choisi et de ne crée qu'une seule instance recipe
  ## cela permettrait d'afficher bien plus que 5 résultats sans trop de souci
  def import
    # Ask a user for a keyword to search
    keyword = @view.ask_for_keyword
    # Make an HTTP request to the recipe’s website with our keyword
    url = "https://www.marmiton.org/recettes/recherche.aspx?aqt=#{keyword}"
    doc = Nokogiri::HTML.parse(URI.parse(url).read, nil, "utf-8")
    # Parse the HTML document to extract the first 5 recipes suggested and store them in an Array
    temp_recipes = import_recipes(doc)
    # Display them in an indexed list
    @view.display_list(temp_recipes)
    # Ask the user which recipe they want to import (ask for an index)
    index = @view.ask_recipe_index
    # Add it to the Cookbook
    @cookbook.create(temp_recipes[index])
  end

  private

  def import_recipes(doc)
    temp_recipes = []
    doc.search(".recipe-card-link").first(5).each do |element|
      name = element.search(".recipe-card__title").text.strip
      url = element["href"]
      rating = element.search(".mrtn-home-rating__rating").text.strip.split('/')[0].to_f
      html_recipe = Nokogiri::HTML.parse(URI.parse(url).read)
      description = ''
      html_recipe.search(".recipe-step-list .recipe-step-list__container").each do |step|
        description << "#{step.search('span').text.strip} \n"
        description << "#{step.search('p').text.strip} \n"
      end
      temp_recipes << Recipe.new(name, description, rating)
    end
    temp_recipes
  end
end
