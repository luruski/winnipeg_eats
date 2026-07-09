class CreateMeals < ActiveRecord::Migration[7.2]
  def change
    create_table :meals do |t|
      t.string :name
      t.text :instructions
      t.string :thumbnail
      t.references :cuisine, null: false, foreign_key: true

      t.timestamps
    end
  end
end
