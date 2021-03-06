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

ActiveRecord::Schema.define(:version => 20150212134458) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "website"
    t.boolean  "order_by_phone"
    t.boolean  "order_by_online"
    t.boolean  "store_farmers_market"
    t.boolean  "third_party_available"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "approved",              :default => false
    t.integer  "user_id"
    t.string   "store_locator_url"
    t.string   "slug"
    t.string   "brand_code"
  end

  add_index "brands", ["name"], :name => "name"
  add_index "brands", ["name"], :name => "name_2"
  add_index "brands", ["order_by_online"], :name => "order_by_online"
  add_index "brands", ["order_by_phone"], :name => "order_by_phone"
  add_index "brands", ["slug"], :name => "index_brands_on_slug", :unique => true
  add_index "brands", ["store_farmers_market"], :name => "store_farmers_market"

  create_table "brands_locations", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "brands_locations", ["brand_id"], :name => "brand_id"
  add_index "brands_locations", ["location_id"], :name => "location_id"

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "sort"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "slug"
  end

  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true
  add_index "categories", ["title"], :name => "title"

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "cms_texts", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "faqs", :force => true do |t|
    t.string   "title"
    t.text     "answer"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "flag_requests", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "flaggable_id"
    t.string   "flaggable_type"
    t.text     "comment"
    t.integer  "user_id"
  end

  add_index "flag_requests", ["flaggable_id"], :name => "index_flag_requests_on_flaggable_id"

  create_table "fovorites", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.integer  "reference_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.string   "phone"
    t.string   "website"
    t.string   "hours"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "parent_id"
    t.string   "location_type"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "slug"
    t.string   "location_code",          :limit => 100, :null => false
    t.string   "state",                  :limit => 50
    t.datetime "coordinates_updated_on"
  end

  add_index "locations", ["latitude"], :name => "latitude"
  add_index "locations", ["longitude"], :name => "longitude"
  add_index "locations", ["slug"], :name => "slug"
  add_index "locations", ["zip"], :name => "zip"

  create_table "locations_products", :force => true do |t|
    t.integer  "product_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "locations_products", ["location_id"], :name => "location_id"
  add_index "locations_products", ["product_id"], :name => "product_id"

  create_table "news_posts", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "website"
    t.text     "body"
    t.binary   "image"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "slug"
  end

  add_index "news_posts", ["slug"], :name => "index_news_posts_on_slug", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "slug"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

  create_table "products", :force => true do |t|
    t.string   "product_key"
    t.integer  "category_id"
    t.integer  "brand_id"
    t.string   "name"
    t.integer  "quality_rating_id"
    t.boolean  "in_stores"
    t.boolean  "available"
    t.string   "not_available"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "approved",             :default => false
    t.integer  "user_id"
    t.string   "slug"
  end

  add_index "products", ["brand_id"], :name => "index_products_on_brand_id"
  add_index "products", ["category_id"], :name => "index_products_on_category_id"
  add_index "products", ["quality_rating_id"], :name => "index_products_on_quality_rating_id"
  add_index "products", ["slug"], :name => "index_products_on_slug", :unique => true

  create_table "promo_codes", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.datetime "redeemed_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "quality_ratings", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.text     "value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "quality_ratings", ["category_id"], :name => "index_quality_ratings_on_category_id"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ratable_id"
    t.string   "ratable_type"
    t.integer  "rating"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "comment"
  end

  add_index "ratings", ["ratable_id"], :name => "ratable_id"
  add_index "ratings", ["ratable_type"], :name => "ratable_type"
  add_index "ratings", ["user_id"], :name => "user_id"

  create_table "sliders", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "approved"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "slider_text"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.string   "subscription_type"
    t.datetime "purchased_at"
    t.datetime "expires_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                   :default => "",    :null => false
    t.string   "encrypted_password",                      :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "facebook_id"
    t.string   "avatar_file_name"
    t.string   "string"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.boolean  "private",                                 :default => false
    t.string   "bio"
    t.boolean  "pro_account",                             :default => false
    t.string   "fname"
    t.string   "password"
    t.string   "provider",                 :limit => 10
    t.string   "uid",                      :limit => 100
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
