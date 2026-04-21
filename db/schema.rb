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

ActiveRecord::Schema[8.0].define(version: 2026_04_21_141813) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blog_con_photos", force: :cascade do |t|
    t.bigint "blog_content_id", null: false
    t.string "alt_ar"
    t.string "alt_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_content_id"], name: "index_blog_con_photos_on_blog_content_id"
  end

  create_table "blog_contents", force: :cascade do |t|
    t.bigint "blog_id", null: false
    t.text "content_ar"
    t.text "content_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id"], name: "index_blog_contents_on_blog_id"
  end

  create_table "blog_photos", force: :cascade do |t|
    t.bigint "blog_id", null: false
    t.string "alt_ar"
    t.string "alt_en"
    t.boolean "is_arabic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id"], name: "index_blog_photos_on_blog_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.string "title_ar"
    t.string "title_en"
    t.text "description_ar"
    t.text "description_en"
    t.string "meta_title_ar"
    t.string "meta_title_en"
    t.string "slug"
    t.string "slug_ar"
    t.text "meta_description_ar"
    t.text "meta_description_en"
    t.boolean "is_published", default: false
    t.integer "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alt_ar"
    t.string "alt_en"
    t.index ["slug"], name: "index_blogs_on_slug", unique: true
    t.index ["slug_ar"], name: "index_blogs_on_slug_ar", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.string "title_ar", null: false
    t.string "title_en", null: false
    t.string "alt_text_ar"
    t.string "alt_text_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_international", default: false
    t.boolean "is_published", default: false
    t.text "description_ar"
    t.text "description_en"
    t.string "meta_title_ar"
    t.string "meta_title_en"
    t.text "meta_description_ar"
    t.text "meta_description_en"
  end

  create_table "company_data", force: :cascade do |t|
    t.string "email"
    t.string "phone_number_1"
    t.string "phone_number_2"
    t.string "whatsapp_number"
    t.string "address_ar"
    t.string "address_en"
    t.string "google_maps_url"
    t.string "working_hours_ar"
    t.string "working_hours_en"
    t.string "facebook_url"
    t.string "instagram_url"
    t.string "twitter_url"
    t.string "linkedin_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "content_photos", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.string "alt_ar"
    t.string "alt_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_content_photos_on_content_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "key", null: false
    t.string "content_type"
    t.integer "position", default: 0, null: false
    t.string "parentable_type"
    t.bigint "parentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "value_en"
    t.text "value_ar"
    t.index ["parentable_type", "parentable_id"], name: "index_contents_on_parentable"
    t.index ["parentable_type", "parentable_id"], name: "index_contents_on_parentable_type_and_parentable_id"
    t.index ["position"], name: "index_contents_on_position"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question_ar"
    t.string "question_en"
    t.text "answer_ar"
    t.text "answer_en"
    t.string "parentable_type"
    t.bigint "parentable_id"
    t.boolean "is_published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parentable_type", "parentable_id"], name: "index_faqs_on_parentable"
  end

  create_table "leaderships", force: :cascade do |t|
    t.string "name_ar", null: false
    t.string "name_en", null: false
    t.string "position_ar"
    t.string "position_en"
    t.text "description_ar"
    t.text "description_en"
    t.string "alt_text_ar"
    t.string "alt_text_en"
    t.integer "display_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_photos", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "alt_ar"
    t.string "alt_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_photos_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title_ar", null: false
    t.string "title_en", null: false
    t.text "description_ar"
    t.text "description_en"
    t.string "alt_text_ar"
    t.string "alt_text_en"
    t.integer "display_order", default: 0
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "brand_id"
    t.boolean "is_published", default: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "page", null: false
    t.string "section_type", null: false
    t.integer "position", default: 0, null: false
    t.jsonb "settings", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page", "section_type"], name: "index_sections_on_page_and_section_type"
    t.index ["page"], name: "index_sections_on_page"
    t.index ["section_type"], name: "index_sections_on_section_type"
    t.index ["settings"], name: "index_sections_on_settings", using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "image"
    t.integer "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blog_con_photos", "blog_contents"
  add_foreign_key "blog_contents", "blogs"
  add_foreign_key "blog_photos", "blogs"
  add_foreign_key "content_photos", "contents"
  add_foreign_key "product_photos", "products"
  add_foreign_key "products", "brands"
end
