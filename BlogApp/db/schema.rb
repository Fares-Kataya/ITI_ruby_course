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

ActiveRecord::Schema[8.0].define(version: 2025_06_09_202045) do
  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.integer "user_id", null: false
    t.boolean "public", default: false
    t.integer "reports_count", default: 0
    t.boolean "archived", default: false
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archived"], name: "index_articles_on_archived"
    t.index ["public"], name: "index_articles_on_public"
    t.index ["reports_count"], name: "index_articles_on_reports_count"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "article_id", null: false
    t.string "reason"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_reports_on_article_id"
    t.index ["user_id", "article_id"], name: "index_reports_on_user_id_and_article_id", unique: true
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "role", default: "user"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "articles", "users"
  add_foreign_key "reports", "articles"
  add_foreign_key "reports", "users"
end
