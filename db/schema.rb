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

ActiveRecord::Schema.define(:version => 20111019040356) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.decimal  "price",      :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "total_price",    :precision => 8, :scale => 2, :default => 0.0
    t.string   "payment_method"
    t.datetime "payment_date"
    t.string   "payment_status",                               :default => "sem acao"
    t.integer  "payment_plots"
    t.string   "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["payment_date"], :name => "index_orders_on_payment_date"
  add_index "orders", ["payment_method"], :name => "index_orders_on_payment_method"
  add_index "orders", ["payment_status"], :name => "index_orders_on_payment_status"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "products", :force => true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.text     "description"
    t.string   "author"
    t.decimal  "price",           :precision => 8, :scale => 2
    t.boolean  "featured"
    t.date     "available_on"
    t.string   "image_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["available_on"], :name => "index_products_on_available_on"
  add_index "products", ["featured"], :name => "index_products_on_featured"

  create_table "sites", :force => true do |t|
    t.string   "domain"
    t.string   "nome"
    t.string   "link_afiliados"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "nome",          :null => false
    t.string   "cpf",           :null => false
    t.date     "data_nasc",     :null => false
    t.text     "endereco",      :null => false
    t.string   "sexo",          :null => false
    t.string   "telefone",      :null => false
    t.string   "celular"
    t.string   "email",         :null => false
    t.string   "password_hash", :null => false
    t.string   "password_salt"
    t.integer  "site_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
