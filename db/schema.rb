# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121125233208) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "locations", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "indoor"
    t.string   "address"
    t.text     "description"
    t.text     "name"
    t.text     "average"
    t.integer  "cache_id"
    t.integer  "people_count"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "locations", ["latitude", "longitude"], :name => "index_locations_on_latitude_and_longitude"

  create_table "places_caches", :force => true do |t|
    t.text     "reference"
    t.string   "vicinity"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "name"
    t.string   "icon"
    t.text     "types"
    t.string   "formatted_phone_number"
    t.string   "international_phone_number"
    t.string   "formatted_address"
    t.string   "address_components"
    t.string   "street_number"
    t.string   "street"
    t.string   "city"
    t.string   "region"
    t.string   "postal_code"
    t.string   "country"
    t.string   "rating"
    t.string   "url"
    t.string   "cid"
    t.string   "website"
    t.text     "google_place_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.text     "comment"
    t.string   "kind"
    t.boolean  "value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",      :default => "", :null => false
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
