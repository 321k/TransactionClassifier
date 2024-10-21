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

ActiveRecord::Schema[7.0].define(version: 2024_03_09_200848) do
  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string "account_number"
    t.string "bank_name"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bank_id", null: false
    t.index ["bank_id"], name: "index_bank_accounts_on_bank_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string "name"
    t.string "requisition_id"
    t.string "link"
    t.integer "household_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gocardless_bank_identifier"
    t.index ["household_id"], name: "index_banks_on_household_id"
  end

  create_table "classifications", force: :cascade do |t|
    t.string "category"
    t.string "sub_category"
    t.integer "confidence_score"
    t.integer "transaction_id"
    t.index ["transaction_id"], name: "index_classifications_on_transaction_id"
  end

  create_table "households", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount"
    t.string "description"
    t.date "booking_date"
    t.date "value_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency"
    t.string "internal_transaction_id"
    t.string "bank_account_id"
  end

  create_table "user_feedbacks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "transaction_id", null: false
    t.integer "classification_id", null: false
    t.string "feedback_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_id"], name: "index_user_feedbacks_on_classification_id"
    t.index ["transaction_id"], name: "index_user_feedbacks_on_transaction_id"
    t.index ["user_id"], name: "index_user_feedbacks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "household_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["household_id"], name: "index_users_on_household_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bank_accounts", "banks"
  add_foreign_key "banks", "households"
  add_foreign_key "classifications", "transactions"
  add_foreign_key "user_feedbacks", "classifications"
  add_foreign_key "user_feedbacks", "transactions"
  add_foreign_key "user_feedbacks", "users"
  add_foreign_key "users", "households"
end
