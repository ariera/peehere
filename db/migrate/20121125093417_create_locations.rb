class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :lat
      t.integer :long
      t.boolean :indoor
      t.string :address
      t.text :description
      t.text :name
      t.text :average

      t.timestamps
    end
  end
end
