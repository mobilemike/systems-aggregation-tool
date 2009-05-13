# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090513011529) do

  create_table "akorri_server_storages", :force => true do |t|
    t.integer  "health"
    t.datetime "last_modified"
    t.string   "historical_health"
    t.integer  "os_type"
    t.string   "os_version"
    t.integer  "server_type"
    t.integer  "memory"
    t.integer  "swap"
    t.integer  "cpu_count"
    t.integer  "cpu_speed"
    t.string   "fqdn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "computer_id"
  end

  create_table "computers", :force => true do |t|
    t.string   "fqdn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scom_computers", :force => true do |t|
    t.string   "bme"
    t.string   "fqdn"
    t.string   "ad_site"
    t.string   "ip"
    t.string   "ou"
    t.integer  "health"
    t.datetime "last_modified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "computer_id"
  end

end
