class CreateRestaurantCuisines < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurant_cuisines do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.references :cuisine, null: false, foreign_key: true

      t.timestamps
    end
  end
end
