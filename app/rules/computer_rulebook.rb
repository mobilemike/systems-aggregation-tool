class ComputerRulebook < Ruleby::Rulebook

  def configuration_issues
    
    # Online Windows computers should be in EPO
    rule [Computer, :c, m.online? == true,
                        m.is_windows? == true,
                        m.in_epo? == false] do |v|
                          
      severity    = 3
      source      = 'EPO'
      identifier  = 'Not in EPO'
      description = "Windows computer is online, but not in EPO"
      
      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Computers in EPO should report their current DAT version accurately
    rule [Computer, :c, m.in_epo? == true,
                        m.ep_dat_outdated > 5000] do |v|
      
      severity    = 3
      source      = 'EPO'
      identifier  = 'DAT not reporting'
      description = "Computer is not reporting it's DAT version accurately"
      
      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Online computers should have a very recent DAT
    rule [Computer, :c, m.online? == true,
                        m.power?.not== false,
                        m.in_epo? == true,
                        m.ep_dat_outdated > 1,
                        m.ep_dat_outdated < 5000] do |v|
                          
      severity    = 2
      source      = 'EPO'
      identifier  = 'DAT out of date'
      description = "Production computer's DAT is #{v[:c].ep_dat_outdated} days old"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # # Production computers that don't run ESX should be in Avamar
    # rule [Computer, :c, m.production? == true,
    #                     m.is_esx? == false,
    #                     m.in_avamar? == false] do |v|
    #   puts "#{v[:c].name}: Production computers that don't run ESX should be in Avamar"
    # end
    
    # Online virtual guests should be in Akorri
    
    rule [Computer, :c, m.online? == true,
                        m.in_esx? == true,
                        m.in_akorri? == false] do |v|

      severity    = 2
      source      = 'Akorri'
      identifier  = 'Not in Akorri'
      description = "ESX guest isn't in Akorri"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Prodcution Windows computers should be in SCOM
    rule [Computer, :c, m.production? == true,
                        m.is_windows? == true,
                        m.in_scom? == false] do |v|

      severity    = 2
      source      = 'SCOM'
      identifier  = 'Not in SCOM'
      description = "Production Windows computer is not in SCOM"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)      
    end
    
    # Online Windows computers should be in WSUS
    rule [Computer, :c, m.online? == true,
                        m.is_windows? == true,
                        m.in_wsus? == false] do |v|

      severity    = 2
      source      = 'WSUS'
      identifier  = 'Not in WSUS'
      description = "Online Windows computer is not in WSUS"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)      
    end
    
    # Online Windows computers shouldn't have outstanding patches
    rule [Computer, :c, m.online? == true,
                        m.is_windows? == true,
                        m.us_outstanding > 0] do |v|
        
      severity    = 2
      source      = 'WSUS'
      identifier  = 'Pending patches'
      description = "Computer has " +
                    ActionController::Base.helpers.pluralize(v[:c].us_outstanding, 'patch') +
                    " outstanding in WSUS"

       assert Issue.find_or_init(v[:c], severity, source, identifier, description)        
    end
    
    # Archived computers shouldn't be powered on
    rule [Computer, :c, m.archived? == true,
                        m.power? == true] do |v|
      
      severity    = 1
      source      = 'Configuration'
      identifier  = 'Powered on'
      description = "Computer in Archived status shouldn't be powered on"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Production virtual guests shouldn't be powered off
    rule [Computer, :c, m.production? == true,
                        m.in_esx? == true,
                        m.power? == false] do |v|
      
      severity    = 2
      source      = 'Configuration'
      identifier  = 'Powered off'
      description = "Computer in Production status shouldn't be powered off"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Online computers should have an owner
    rule [Computer, :c, m.online? == true,
                        m.owner_id? == false] do |v|
      
      severity    = 1
      source      = 'Configuration'
      identifier  = 'No Owner'
      description = "Online computers should have an owner"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    
    # Decommissioned computers shouldn't be listed as active in WSUS
    rule [Computer, :c, m.decommissioned? == true,
                        m.in_wsus? == true] do |v|
      
      severity    = 1
      source      = 'Configuration'
      identifier  = 'In WSUS'
      description = "Computer in Decommissioned status shouldn't be in WSUS"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Decommissioned computers shouldn't be listed as active in EPO
    rule [Computer, :c, m.decommissioned? == true,
                        m.in_epo? == true] do |v|
      
      severity    = 1
      source      = 'Configuration'
      identifier  = 'In EPO'
      description = "Computer in Decommissioned status shouldn't be in EPO"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Decommissioned computers shouldn't be listed in SCOM
    rule [Computer, :c, m.decommissioned? == true,
                        m.in_scom? == true] do |v|
      
      severity    = 1
      source      = 'Configuration'
      identifier  = 'In SCOM'
      description = "Computer in Decommissioned status shouldn't be in SCOM"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Decommissioned computers shouldn't be listed in AD
    rule [Computer, :c, m.decommissioned? == true,
                        m.in_ldap? == true] do |v|
      
      severity    = 1
      source      = 'Configuration'
      identifier  = 'In AD'
      description = "Computer in Decommissioned status shouldn't be in AD"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Decommissioned computers shouldn't be listed in ESX
    rule [Computer, :c, m.decommissioned? == true,
                        m.in_esx? == true] do |v|
      
      severity    = 1
      source      = 'Configuration'
      identifier  = 'In ESX'
      description = "Computer in Decommissioned status shouldn't be in ESX"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Decommissioned computers shouldn't be listed in Akorri
    rule [Computer, :c, m.decommissioned? == true,
                        m.in_akorri? == true] do |v|
      
      severity    = 1
      source      = 'Configuration'
      identifier  = 'In Akorri'
      description = "Computer in Decommissioned status shouldn't be in Akorri"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Decommissioned computers shouldn't be listed as active in Avamar
    rule [Computer, :c, m.decommissioned? == true,
                        m.in_avamar? == true] do |v|
      
      severity    = 1
      source      = 'Configuration'
      identifier  = 'In Avamar'
      description = "Computer in Decommissioned status shouldn't be active in Avamar"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Online virtual windows guests should be in a domain
    rule [Computer, :c, m.online? == true,
                        m.is_windows? == true,
                        m.in_ldap? == false] do |v|

      severity    = 3
      source      = 'AD'
      identifier  = 'Not in AD'
      description = "Online Windows computer isn't in AD"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # All computers in AD should have a description
    rule [Computer, :c, m.in_ldap? == true,
                        m.description? == false] do |v|
                          
      severity    = 1
      source      = 'AD'
      identifier  = 'No description'
      description = "Computer must have a description set in AD"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
  end

end
