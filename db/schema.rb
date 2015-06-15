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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150405113542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "subject",    limit: 255
    t.text     "body"
    t.datetime "expires_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type",  limit: 255
    t.integer  "associated_id"
    t.string   "associated_type", limit: 255
    t.integer  "user_id"
    t.string   "user_type",       limit: 255
    t.string   "username",        limit: 255
    t.string   "action",          limit: 255
    t.text     "audited_changes"
    t.integer  "version",                     default: 0
    t.string   "comment",         limit: 255
    t.string   "remote_address",  limit: 255
    t.datetime "created_at"
    t.string   "request_uuid"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "categories_issues", force: :cascade do |t|
    t.integer "category_id"
    t.integer "issue_id"
  end

  create_table "categories_todos", force: :cascade do |t|
    t.integer "category_id"
    t.integer "todo_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "issue_id"
    t.text     "body"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["issue_id"], name: "index_comments_on_issue_id", using: :btree
  add_index "comments", ["member_id"], name: "index_comments_on_member_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "title",       limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.string   "class_name",  limit: 255
    t.boolean  "all_day"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "icon",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "member_id"
    t.boolean  "password_is_temp"
    t.datetime "sent_at"
    t.datetime "accepted_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "invitations", ["member_id"], name: "index_invitations_on_member_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "description", limit: 255
    t.boolean  "is_resolved"
    t.integer  "member_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "subject",     limit: 255
    t.integer  "position"
    t.date     "resolved_at"
    t.boolean  "is_critical"
  end

  add_index "issues", ["member_id"], name: "index_issues_on_member_id", using: :btree
  add_index "issues", ["project_id"], name: "index_issues_on_project_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.boolean  "is_admin"
    t.datetime "joined_date"
    t.string   "status_code", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "members", ["project_id"], name: "index_members_on_project_id", using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.text     "description",                  default: ""
    t.integer  "status_code"
    t.boolean  "is_complete"
    t.string   "token_for_disqus", limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",         limit: 255, null: false
    t.text     "value"
    t.integer  "target_id",               null: false
    t.string   "target_type", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "settings", ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true, using: :btree

  create_table "todos", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "member_id"
    t.string   "subject",      limit: 255
    t.date     "due_date"
    t.boolean  "is_complete"
    t.date     "completed_at"
    t.integer  "position"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "description",  limit: 255
    t.boolean  "is_critical"
  end

  add_index "todos", ["member_id"], name: "index_todos_on_member_id", using: :btree
  add_index "todos", ["project_id"], name: "index_todos_on_project_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "name",                   limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "plan",                   limit: 255
    t.string   "stripe_customer_id",     limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
