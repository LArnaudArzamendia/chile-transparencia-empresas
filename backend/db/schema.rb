# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_11_29_012144) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "rut"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "normalized_rut"
    t.index ["name"], name: "index_companies_on_name"
    t.index ["rut"], name: "index_companies_on_rut"
  end

  create_table "company_representatives", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "representative_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_representatives_on_company_id"
    t.index ["representative_id"], name: "index_company_representatives_on_representative_id"
  end

  create_table "representatives", force: :cascade do |t|
    t.string "rut"
    t.string "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "normalized_rut"
    t.index ["full_name"], name: "index_representatives_on_full_name"
    t.index ["rut"], name: "index_representatives_on_rut"
  end

  add_foreign_key "company_representatives", "companies"
  add_foreign_key "company_representatives", "representatives"
end
