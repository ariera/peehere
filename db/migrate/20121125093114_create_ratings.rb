class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :location_id
      t.text :comment
      t.string :kind
      t.boolean :value

      t.timestamps
    end
  end
end
