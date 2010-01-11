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

ActiveRecord::Schema.define(:version => 20100109200333) do

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

  create_table "avamar_computers", :force => true do |t|
    t.integer  "computer_id"
    t.string   "fqdn"
    t.string   "avamar_domain"
    t.string   "group_name"
    t.string   "type"
    t.string   "dataset"
    t.boolean  "dataset_override"
    t.string   "retention_policy"
    t.date     "effective_expiration"
    t.boolean  "retention_policy_override"
    t.string   "schedule"
    t.datetime "scheduled_start_at"
    t.datetime "scheduled_end_at"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer  "num_of_files"
    t.float    "bytes_scanned"
    t.float    "bytes_new"
    t.float    "bytes_modified"
    t.float    "bytes_modified_sent"
    t.float    "bytes_modified_not_sent"
    t.integer  "status_code"
    t.integer  "error_code"
    t.float    "bytes_excluded"
    t.float    "bytes_skipped"
    t.float    "num_files_skipped"
    t.string   "client_os"
    t.string   "client_ver"
    t.float    "bytes_overhead"
    t.string   "status_code_summary"
    t.string   "error_code_summary"
    t.string   "retention"
    t.string   "ip"
    t.date     "avamar_created_at"
    t.boolean  "enabled"
    t.boolean  "restore_only"
    t.date     "modified_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "computers", :force => true do |t|
    t.string   "fqdn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.float    "cpu_reaady"
    t.string   "disposition"
    t.string   "bios_name"
    t.string   "bios_ver"
    t.integer  "cpu_count"
    t.string   "cpu_name"
    t.float    "cpu_ready"
    t.integer  "cpu_reservation"
    t.integer  "cpu_speed"
    t.boolean  "guest"
    t.boolean  "host"
    t.integer  "host_computer_id"
    t.string   "hp_mgmt_ver"
    t.integer  "ilo_ip",           :limit => 8
    t.datetime "install_date"
    t.integer  "ip",               :limit => 8
    t.string   "last_logged_on"
    t.string   "mac"
    t.integer  "mem_baloon"
    t.integer  "mem_free"
    t.integer  "mem_reservation"
    t.integer  "mem_swap"
    t.integer  "mem_total"
    t.string   "model"
    t.string   "os_kernel_ver"
    t.string   "os_type"
    t.string   "os_vendor"
    t.string   "os_version"
    t.string   "serial_number"
    t.integer  "subnet_mask",      :limit => 8
    t.float    "vcpu_efficiency"
    t.float    "vcpu_used"
  end

  add_index "computers", ["fqdn"], :name => "index_computers_on_fqdn"

  create_table "epo_computers", :force => true do |t|
    t.integer  "computer_id"
    t.string   "fqdn"
    t.integer  "cpu_speed"
    t.string   "cpu_type"
    t.integer  "memory_free"
    t.string   "ip"
    t.string   "mac"
    t.integer  "cpu_count"
    t.float    "os_version"
    t.string   "os_type"
    t.string   "os_platform"
    t.string   "os_sp"
    t.string   "subnet"
    t.string   "subnet_mask"
    t.integer  "memory"
    t.string   "last_user"
    t.datetime "last_update"
    t.integer  "dat_version"
    t.integer  "dat_health"
    t.integer  "update_health"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "owners", :force => true do |t|
    t.string   "name"
    t.string   "initials"
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
    t.string   "owner_id"
    t.boolean  "virtual"
    t.string   "model"
    t.string   "serial_number"
    t.string   "bios_firmware"
    t.string   "management_version"
    t.string   "ilo_ip"
    t.datetime "install_date"
    t.integer  "cpus"
    t.string   "domain"
    t.integer  "scom_cpu_perf_id"
    t.integer  "scom_memory_perf_id"
    t.string   "os_version_number"
    t.integer  "memory"
    t.string   "os"
    t.integer  "os_sp"
    t.integer  "cores"
    t.string   "server_2008_install_type"
  end

  create_table "vmware_computers", :force => true do |t|
    t.integer  "computer_id"
    t.string   "name"
    t.integer  "power"
    t.string   "os"
    t.string   "os_family"
    t.integer  "memory"
    t.integer  "cpu_count"
    t.integer  "nic_count"
    t.string   "fqdn"
    t.string   "ip"
    t.integer  "tools_status"
    t.integer  "tools_version"
    t.datetime "boot_time"
    t.integer  "memory_overhead"
    t.string   "description"
    t.integer  "host_computer_id"
    t.integer  "type"
    t.integer  "vmotion"
    t.string   "os_version"
    t.integer  "os_build"
    t.string   "vendor"
    t.string   "model"
    t.string   "cpu_type"
    t.integer  "cpu_speed"
    t.integer  "hba_count"
    t.integer  "maintenance_mode"
    t.integer  "cpu_health"
    t.integer  "memory_health"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wsus_computers", :force => true do |t|
    t.integer  "computer_id"
    t.string   "fqdn"
    t.datetime "last_sync"
    t.datetime "last_status"
    t.datetime "last_reboot"
    t.string   "ip_address"
    t.integer  "os_major"
    t.integer  "os_minor"
    t.integer  "os_build"
    t.integer  "os_sp"
    t.string   "make"
    t.string   "model"
    t.string   "bios_ver"
    t.string   "bios_name"
    t.date     "bios_date"
    t.string   "processor_type"
    t.datetime "wsus_created_at"
    t.string   "client_ver"
    t.integer  "updates_unknown"
    t.integer  "updates_not_installed"
    t.integer  "updates_downloaded"
    t.integer  "updates_installed"
    t.integer  "updates_failed"
    t.integer  "updates_pending_reboot"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "computer_hash"
    t.integer  "updates_approved"
  end

end
