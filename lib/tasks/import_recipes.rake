task import_recipes: :environment do
  data = File.open('tmp/recipes_test.json')
  data.each do |line|
    recipe_data = JSON.parse(line)

    recipe = Recipe.create(
      name: recipe_data['name'],
      rate: recipe_data['rate'],
      prep_time: recipe_data['prep_time'],
      cook_time: recipe_data['cook_time'],
      total_time: recipe_data['total_time'],
      people_quantity: recipe_data['people_quantity'],
      author: recipe_data['author'],
      difficulty: recipe_data['difficulty']
    )
    ingredients = recipe_data['ingredients'].map do |ingredient|
      ingredient_id = Ingredient.find_or_create_by(name: ingredient)
    end
    recipe.ingredients << ingredients
  end
end