class View
  def display_recipe(recipe)
    "#{recipe.name} - Rating: #{recipe.rating} / 5\nDescription :\n#{recipe.description}"
  end

  def display_list(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. #{display_recipe(recipe)}\n\n"
    end
  end

  def ask_recipe_name
    puts "Enter the name of the recipe"
    print '> '
    gets.chomp
  end

  def ask_recipe_description
    puts "Enter the description of the recipe"
    print '> '
    gets.chomp
  end

  def ask_recipe_rating
    puts "Enter the rating of the recipe (1..5)"
    print '> '
    gets.chomp.to_f
  end

  def ask_recipe_index
    puts "Enter the index of the recipe"
    print '> '
    gets.chomp.to_i - 1
  end

  def ask_for_keyword
    puts 'What ingredient would you like a recipe for?'
    print '> '
    gets.chomp
  end
end
