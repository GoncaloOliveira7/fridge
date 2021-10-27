class Api::V1::RecipesController < ApplicationController
  def index
    ingredients = params.permit(:ingredients)['ingredients'].gsub(/ /, '|')

    recipes_ids = Recipe.joins(:ingredients).where("ingredients.name similar to '%#{ingredients}%'").ids
    @recipes = Recipe.where(id: recipes_ids).order(name: :asc)
    render json: @recipes
  end

end
