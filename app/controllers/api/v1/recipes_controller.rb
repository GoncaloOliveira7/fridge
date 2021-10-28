class Api::V1::RecipesController < ApplicationController
  def index
    ingredients = params.permit(:ingredients)['ingredients'].gsub(/ /, '|')

    @recipes = Recipe
      .distinct
      .joins(:ingredients)
      .where("ingredients.name similar to '%#{ingredients}%'")
      .where(id: Recipe.joins(:ingredients).group(:id).having('count("recipes"."id") <= ?', ingredients.split('|').count).ids)

    render json: @recipes
  end
end
