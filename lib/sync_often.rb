#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= ARGV.first || "development"
require File.dirname(__FILE__) + "/../config/environment"

gem 'dbi', :version => '0.4.1'
gem 'dbd-odbc', :version => '0.2.4', :lib => 'dbd/ODBC'
require 'dbi'
require 'sync_akorri'
require 'sync_epo'
require 'sync_scom'
require 'sync_vcenter'
require 'sync_vcenter-fdc'
require 'sync_vcenter-idc'
require 'sync_wsus'
require 'sync_wsus_sonesta'
require 'sync_avamar'
require 'sync_ldap'
require 'sync_sccm'
require 'run_rules'
require 'cleanup'


sync_scom
sync_vcenter
sync_vcenter_fdc
sync_vcenter_idc
sync_akorri
sync_wsus
sync_wsus_sonesta
sync_epo
sync_avamar
sync_ldap
sync_sccm
run_rules
cleanup