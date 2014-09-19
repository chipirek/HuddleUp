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

ActiveRecord::Schema.define(:version => 20140919200124) do

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "invitations", :force => true do |t|
    t.integer  "member_id"
    t.boolean  "password_is_temp"
    t.datetime "sent_at"
    t.datetime "accepted_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "invitations", ["member_id"], :name => "index_invitations_on_member_id"

  create_table "issues", :force => true do |t|
    t.integer  "project_id"
    t.string   "description"
    t.boolean  "is_resolved"
    t.integer  "member_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "subject"
  end

  add_index "issues", ["member_id"], :name => "index_issues_on_member_id"
  add_index "issues", ["project_id"], :name => "index_issues_on_project_id"

  create_table "members", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.boolean  "is_admin"
    t.datetime "joined_date"
    t.string   "status_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "members", ["project_id"], :name => "index_members_on_project_id"
  add_index "members", ["user_id"], :name => "index_members_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "project_id"
    t.integer  "member_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "messages", ["member_id"], :name => "index_messages_on_member_id"
  add_index "messages", ["project_id"], :name => "index_messages_on_project_id"

  create_table "milestones", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.date     "start"
    t.date     "end"
    t.string   "class_name"
    t.boolean  "all_day"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "milestones", ["project_id"], :name => "index_milestones_on_project_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description",      :default => ""
    t.integer  "status_code"
    t.boolean  "is_complete"
    t.string   "token_for_disqus"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "read_receipts", :force => true do |t|
    t.integer  "member_id"
    t.integer  "message_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "read_receipts", ["member_id"], :name => "index_read_receipts_on_member_id"
  add_index "read_receipts", ["message_id"], :name => "index_read_receipts_on_message_id"

  create_table "todos", :force => true do |t|
    t.integer  "project_id"
    t.integer  "member_id"
    t.string   "subject"
    t.date     "due_date"
    t.boolean  "is_complete"
    t.date     "completed_at"
    t.integer  "position"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "description"
  end

  add_index "todos", ["member_id"], :name => "index_todos_on_member_id"
  add_index "todos", ["project_id"], :name => "index_todos_on_project_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "name",                   :default => "", :null => false
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

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
