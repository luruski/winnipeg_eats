class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
