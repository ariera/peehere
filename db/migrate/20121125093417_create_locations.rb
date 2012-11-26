class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :indoor
      t.string :address
      t.text :description
      t.text :name
      t.text :average
      t.integer :cache_id
      t.integer :people_count

      t.timestamps
    end
    add_index :locations, [:latitude, :longitude]
  end
end
