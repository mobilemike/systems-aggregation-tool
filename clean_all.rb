#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= ARGV.first || "development"
require File.dirname(__FILE__) + "/../config/environment"

require 'sync_akorri'
require 'sync_epo'
require 'sync_scom'
require 'sync_vcenter'
require 'sync_wsus'
require 'sync_avamar'
require 'sync_ldap'

sync_scom
sync_vcenter
sync_akorri
sync_wsus
sync_epo
sync_avamar
sync_ldap