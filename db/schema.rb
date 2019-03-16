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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_08_063253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "full_name", null: false
    t.string "company_name"
    t.string "tax_type"
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["full_name"], name: "index_admin_users_on_full_name"
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_admin_users_on_role"
  end

  create_table "catagories", force: :cascade do |t|
    t.string "created_by", null: false
    t.string "name"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.string "expense"
    t.text "description"
    t.decimal "price"
    t.string "created_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_items", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "sale_id"
    t.decimal "selling_price"
    t.integer "pre_quantity"
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_items_on_product_id"
    t.index ["sale_id"], name: "index_product_items_on_sale_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "catagory_id"
    t.string "created_by", null: false
    t.string "product_name", null: false
    t.string "photo"
    t.decimal "unit_price", null: false
    t.text "description"
    t.string "serial_number"
    t.integer "quantity", null: false
    t.decimal "selling_price"
    t.string "type_of_sales"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catagory_id"], name: "index_products_on_catagory_id"
    t.index ["product_name"], name: "index_products_on_product_name"
  end

  create_table "sales", force: :cascade do |t|
    t.string "customer_name"
    t.string "phone_number"
    t.string "address"
    t.boolean "include_tax"
    t.string "type_of_sales"
    t.decimal "total_price"
    t.decimal "down_payment"
    t.boolean "fully_payed"
    t.string "created_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "product_id"
    t.string "tag_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_tags_on_product_id"
  end

  add_foreign_key "product_items", "products"
  add_foreign_key "product_items", "sales"
  add_foreign_key "products", "catagories"
  add_foreign_key "tags", "products"
end
