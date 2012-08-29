#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= ARGV.first || "development"
require File.dirname(__FILE__) + "/../config/environment"

gem 'dbi', :version => '0.4.1'
gem 'dbd-odbc', :version => '0.2.4', :lib => 'dbd/ODBC'
require 'dbi'
require 'sync_epo_pcs'
require 'sync_wsus_pcs_rmr'
require 'sync_wsus_pcs_fve'
require 'sync_ldap_pcs'
require 'sync_sccm_pcs'
require 'cleanup_pcs'

sync_wsus_rmr
sync_wsus_fve
sync_epo
sync_ldap
sync_sccm
cleanup_pcs