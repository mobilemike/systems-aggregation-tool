#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= ARGV.first || "development"
require File.dirname(__FILE__) + "/../config/environment"


gem 'dbi', :version => '0.4.1'
gem 'dbd-odbc', :version => '0.2.4', :lib => 'dbd/ODBC'
require 'dbi'
require 'sync_scom_uptime'

sync_scom_uptime

Computer.delete_all(:disposition => "remove")
Computer.update_all(
  :ak_cpu_last_modified => nil,
  :ak_mem_last_modified => nil,
  :ak_storage_last_modified => nil,
  :av_completed_at => nil,
  :av_error => nil,
  :av_excluded => nil,
  :av_file_count => nil,
  :av_file_skipped_count => nil,
  :av_modified => nil,
  :av_new => nil,
  :av_scanned => nil,
  :av_skipped => nil,
  :av_started_at => nil,
  :av_status => nil,
  :boot_time => nil,
  :cpu_ready => nil,
  :ep_dat_outdated => nil,
  :ep_dat_version => nil,
  :ep_last_update => nil,
  :health_ak_cpu => nil,
  :health_ak_mem => nil,
  :health_ak_storage => nil,
  :health_sc_state => nil,
  :health_vm_vtools => nil,
  :host_computer_id => nil,
  :in_akorri => nil,
  :in_avamar => nil,
  :in_epo => nil,
  :in_esx => nil,
  :in_ldap => nil,
  :in_sccm => nil,
  :in_scom => nil,
  :in_wsus => nil,
  :mem_balloon => nil,
  :mem_used => nil,
  :power => nil,
  :sc_cpu_perf_id => nil,
  :sc_mem_perf_id => nil,
  :us_approved => nil,
  :us_downloaded => nil,
  :us_failed => nil,
  :us_installed => nil,
  :us_last_sync => nil,
  :us_not_installed => nil,
  :us_pending_reboot => nil,
  :us_unknown => nil,
  :vcpu_efficiency => nil,
  :vcpu_used => nil,
  :vtools_ver => nil
)

Pc.update_all(
  :in_epo  => nil,
  :in_wsus => nil,
  :in_ldap => nil,
  :in_sccm => nil,
  :mem_used => nil,
  :mem_swap => nil,
  :ep_dat_version => nil,
  :ep_dat_outdated => nil,
  :us_approved => nil,
  :us_downloaded => nil,
  :us_failed => nil,
  :us_installed => nil,
  :us_not_installed => nil,
  :us_pending_reboot => nil,
  :us_unknown => nil
)