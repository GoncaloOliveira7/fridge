class Api::V1::RecipesController < ApplicationController
  def index
    permit_params = params.permit(:ingredients, :showAll)

    show_all = permit_params[:showAll] == 'true'
    ingredients = permit_params[:ingredients].split(',').map { |e| "%#{ActiveRecord::Base::sanitize_sql_like(e.strip)}%" }

    if show_all
      having = 'true'
    else
      having = ActiveRecord::Base::sanitize_sql_array(["count(ingredients) = count(ingredients.id) filter (where ingredients.name like any (array[:ingredients]))", ingredients: ingredients])
    end

    @recipes = Recipe.joins(:ingredients)
      .select(ActiveRecord::Base::sanitize_sql_array(["
        recipes.*,
        count(ingredients) as unfiltered,
        count(ingredients.id) filter (where ingredients.name like any (array[:ingredients])) as filtered,
        case
          WHEN count(ingredients.id) filter (where ingredients.name like any (array[:ingredients])) = 0 THEN 4
          WHEN count(ingredients) = count(ingredients.id) filter (where ingredients.name like any (array[:ingredients])) THEN 1
          WHEN count(ingredients) < count(ingredients.id) filter (where ingredients.name like any (array[:ingredients])) THEN 2
          WHEN count(ingredients) > count(ingredients.id) filter (where ingredients.name like any (array[:ingredients])) THEN 3
        END priority
      ", ingredients: ingredients]))
      .group(:id)
      .having(having)
      .order(priority: :asc, name: :asc)

    render json: @recipes
  end
end
