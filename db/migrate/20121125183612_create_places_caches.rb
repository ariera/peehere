class CreatePlacesCaches < ActiveRecord::Migration
  def up
    create_table :places_caches do |t|
      t.text   :reference
      t.string :vicinity
      t.float  :latitude
      t.float  :longitude
      t.string :name
      t.string :icon
      t.text   :types
      t.string :formatted_phone_number
      t.string :international_phone_number
      t.string :formatted_address
      t.string :address_components
      t.string :street_number
      t.string :street
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country
      t.string :rating
      t.string :url
      t.string :cid
      t.string :website
      t.text   :google_place_id, limit:1000

      t.timestamps
    end
    #add_index :places_caches, :google_place_id, :uniq => true
  end

  def down
    drop_table :places_caches
  end
end
