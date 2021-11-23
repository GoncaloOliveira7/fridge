class Api::V1::RecipesController < ApplicationController
  def index
    show_all = true
    ingredients = params.permit(:ingredients)['ingredients'].split(',').map { |e| "%#{ActiveRecord::Base::sanitize_sql_like(e.strip)}%" }

    if show_all
      having = 'true'
    else
      # having = 'count(ingredients) =
      # (SELECT count(*)
      # FROM "recipes" post_table
      # INNER JOIN "ingredients_recipes" ON "ingredients_recipes"."recipe_id" = "recipes"."id"
      # INNER JOIN "ingredients" ON "ingredients"."id" = "ingredients_recipes"."ingredient_id"
      # WHERE post_table.id = recipes.id)'

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
      # .having(ActiveRecord::Base::sanitize_sql_array(["count(ingredients.id) filter (where ingredients.name like any (array[:ingredients])) > 0 #{having}", ingredients: ingredients]))
      .having(having)
      .order(priority: :asc)

      # .having(having)
    # @recipes = Recipe.joins(:ingredients).where(id: recipe_ids).group(:id)


    render json: @recipes
  end
end
