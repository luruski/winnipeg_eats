class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.string :author
      t.integer :rating
      t.text :body
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
