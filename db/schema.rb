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

ActiveRecord::Schema.define(:version => 20101104122959) do

  create_table "computers", :force => true do |t|
    t.string   "fqdn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "disposition"
    t.date     "bios_date"
    t.string   "bios_name"
    t.string   "bios_ver"
    t.datetime "boot_time"
    t.integer  "cpu_count"
    t.string   "cpu_name"
    t.float    "cpu_ready"
    t.integer  "cpu_reservation"
    t.integer  "cpu_speed"
    t.text     "description"
    t.boolean  "guest",                    :default => false,     :null => false
    t.boolean  "host",                     :default => false
    t.integer  "host_computer_id"
    t.string   "hp_mgmt_ver"
    t.integer  "ilo_ip_int"
    t.datetime "install_date"
    t.integer  "ip_int"
    t.string   "last_logged_on"
    t.string   "mac"
    t.string   "make"
    t.integer  "mem_balloon"
    t.integer  "mem_reservation"
    t.integer  "mem_swap"
    t.integer  "mem_total"
    t.integer  "mem_used"
    t.string   "model"
    t.boolean  "os_64"
    t.string   "os_edition"
    t.string   "os_kernel_ver"
    t.string   "os_name"
    t.integer  "os_sp"
    t.string   "os_vendor"
    t.string   "os_version"
    t.boolean  "power"
    t.string   "serial_number"
    t.integer  "subnet_mask_int"
    t.integer  "vtools_ver"
    t.float    "vcpu_efficiency"
    t.float    "vcpu_used"
    t.integer  "health_ak_cpu"
    t.datetime "ak_cpu_last_modified"
    t.integer  "health_ak_storage"
    t.datetime "ak_storage_last_modified"
    t.integer  "health_ak_mem"
    t.datetime "ak_mem_last_modified"
    t.integer  "health_sc_state"
    t.integer  "sc_cpu_perf_id"
    t.integer  "sc_mem_perf_id"
    t.datetime "ep_last_update"
    t.integer  "ep_dat_version"
    t.integer  "health_vm_vtools"
    t.string   "av_dataset"
    t.string   "av_retention"
    t.string   "av_schedule"
    t.datetime "av_started_at"
    t.datetime "av_completed_at"
    t.integer  "av_file_count"
    t.float    "av_scanned"
    t.float    "av_new"
    t.float    "av_modified"
    t.float    "av_excluded"
    t.float    "av_skipped"
    t.integer  "av_file_skipped_count"
    t.string   "av_status"
    t.string   "av_error"
    t.datetime "us_last_sync"
    t.integer  "us_unknown",               :default => 0
    t.integer  "us_not_installed",         :default => 0
    t.integer  "us_downloaded",            :default => 0
    t.integer  "us_installed",             :default => 0
    t.integer  "us_failed",                :default => 0
    t.integer  "us_pending_reboot",        :default => 0
    t.integer  "us_approved",              :default => 0
    t.integer  "ep_dat_outdated"
    t.string   "company",                  :default => "Unknown"
    t.boolean  "in_akorri"
    t.boolean  "in_avamar"
    t.boolean  "in_epo"
    t.boolean  "in_scom"
    t.boolean  "in_esx"
    t.boolean  "in_wsus"
    t.boolean  "in_ldap"
    t.string   "us_group_name"
    t.integer  "total_disk"
    t.integer  "free_disk"
    t.string   "sc_bme"
    t.float    "sc_uptime_percentage"
    t.integer  "health",                   :default => 0
    t.integer  "health_rank",              :default => 0
    t.boolean  "exempt_scom",              :default => false
    t.boolean  "exempt_ldap",              :default => false
    t.boolean  "exempt_avamar",            :default => false
    t.boolean  "exempt_akorri",            :default => false
    t.boolean  "exempt_epo",               :default => false
    t.boolean  "exempt_wsus",              :default => false
    t.integer  "mem_vm_host_used"
    t.string   "location"
    t.boolean  "in_sccm"
    t.boolean  "exempt_sccm"
    t.boolean  "dhcp"
    t.integer  "default_gateway_int"
    t.integer  "time_zone_offset"
    t.string   "service_category",         :default => "Unknown"
  end

  add_index "computers", ["fqdn"], :name => "index_computers_on_fqdn"

  create_table "issues", :force => true do |t|
    t.string   "identifier"
    t.string   "source"
    t.text     "description"
    t.integer  "computer_id"
    t.integer  "severity"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issues", ["active"], :name => "issues_active_idx"
  add_index "issues", ["computer_id"], :name => "issues_computer_id_idx"

  create_table "owners", :force => true do |t|
    t.string   "name"
    t.string   "initials"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pcs", :force => true do |t|
    t.string   "fqdn"
    t.integer  "cpu_speed"
    t.integer  "cpu_count"
    t.string   "cpu_name"
    t.date     "bios_date"
    t.string   "bios_name"
    t.string   "bios_ver"
    t.datetime "boot_time"
    t.integer  "ip_int"
    t.string   "last_logged_on"
    t.string   "mac"
    t.string   "make"
    t.integer  "mem_total"
    t.integer  "mem_used"
    t.string   "model"
    t.string   "os_sp"
    t.string   "os_version"
    t.string   "serial_number"
    t.integer  "subnet_mask_int"
    t.datetime "ep_last_update"
    t.integer  "ep_dat_version"
    t.integer  "ep_dat_outdated"
    t.string   "company",             :default => "Unknown"
    t.boolean  "in_epo"
    t.boolean  "in_wsus"
    t.boolean  "in_ldap"
    t.boolean  "in_sccm"
    t.string   "us_group_name"
    t.integer  "disk_total"
    t.integer  "disk_free"
    t.datetime "us_last_sync"
    t.integer  "us_unknown",          :default => 0
    t.integer  "us_not_installed",    :default => 0
    t.integer  "us_downloaded",       :default => 0
    t.integer  "us_installed",        :default => 0
    t.integer  "us_failed",           :default => 0
    t.integer  "us_pending_reboot",   :default => 0
    t.integer  "us_approved",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "dhcp"
    t.integer  "default_gateway_int"
    t.integer  "time_zone_offset"
    t.datetime "install_date"
    t.integer  "mem_swap"
    t.string   "os_edition"
    t.datetime "cm_last_heartbeat"
  end

  add_index "pcs", ["fqdn"], :name => "pcs_fqdn_index"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
