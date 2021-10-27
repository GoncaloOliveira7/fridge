class CreateRecipeIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients_recipes do |t|
      t.belongs_to :recipe
      t.belongs_to :ingredient

      t.timestamps
    end
  end
end
