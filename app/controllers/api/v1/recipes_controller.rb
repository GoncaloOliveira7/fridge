class Api::V1::RecipesController < ApplicationController
  def index
    ingredients = params.permit(:ingredients)['ingredients'].split(' ').map { |e| "%#{e}%" }

    recipe_ids = Recipe.joins(:ingredients)
      .where("ingredients.name like any (array[?])", ingredients)
      .group(:id)
      .having('count(ingredients.id) =
        (SELECT count(*)
        FROM "recipes" post_table
        INNER JOIN "ingredients_recipes" ON "ingredients_recipes"."recipe_id" = "recipes"."id"
        INNER JOIN "ingredients" ON "ingredients"."id" = "ingredients_recipes"."ingredient_id"
        WHERE post_table.id = recipes.id)')
      .ids
    @recipes = Recipe.where(id: recipe_ids)

    render json: @recipes
  end
end
