class ComputerRulebook < Ruleby::Rulebook

  def configuration_issues
    
    # Online Windows computers should be in EPO
    rule [Computer, :c, m.online? == true,
                        m.is_windows? == true,
                        m.in_epo? == false,
                        m.exempt_epo? == false] do |v|
                          
      severity    = 5
      source      = 'Configuration'
      identifier  = 'Not in EPO'
      description = "Windows computer is online, but not in EPO"
      
      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Computers in EPO should report their current DAT version accurately
    rule [Computer, :c, m.in_epo? == true,
                        m.exempt_epo? == false,
                        m.ep_dat_outdated > 5000] do |v|
      
      severity    = 5
      source      = 'EPO'
      identifier  = 'DAT not reporting'
      description = "Computer is not reporting it's DAT version accurately"
      
      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Online computers should have a very recent DAT
    rule [Computer, :c, m.online? == true,
                        m.power?.not== false,
                        m.in_epo? == true,
                        m.exempt_epo? == false,
                        m.ep_dat_outdated > 1,
                        m.ep_dat_outdated < 5000] do |v|
                          
      severity    = 4
      source      = 'EPO'
      identifier  = 'DAT out of date'
      description = "Online computer's DAT is #{v[:c].ep_dat_outdated} days old"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Avmar protected comptuters should backup without error 
    rule [Computer, :c, m.in_avamar? == true,
                        m.exempt_avamar? == false,
                        m.health_av_last > 0] do |v|


      severity    = v[:c].health_av_last + 2
      source      = 'Avamar'
      identifier  = 'Last Backup Status'
      description = v[:c].av_message
      
      assert Issue.find_or_init(v[:c], severity, source, identifier, description)      
    end
    
    # Online virtual guests should be in Akorri
    rule [Computer, :c, m.online? == true,
                        m.in_esx? == true,
                        m.in_akorri? == false,
                        m.exempt_akorri? == false] do |v|

      severity    = 4
      source      = 'Configuration'
      identifier  = 'Not in Akorri'
      description = "ESX guest isn't in Akorri"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Prodcution Windows computers should be in SCOM
    rule [Computer, :c, m.production? == true,
                        m.is_windows? == true,
                        m.in_scom? == false,
                        m.exempt_scom? == false] do |v|

      severity    = 4
      source      = 'Configuration'
      identifier  = 'Not in SCOM'
      description = "Production Windows computer is not in SCOM"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)      
    end
    
    # SCOM health state should create an alert to that effect
    rule [Computer, :c, m.in_scom? == true,
                        m.exempt_scom? == false,
                        m.health_sc_state > 1] do |v|

      state_in_words = case v[:c].health_sc_state
        when 2 then "warning"
        when 3 then "critical"
      end

      severity    = v[:c].health_sc_state + 2
      source      = 'SCOM'
      identifier  = 'System State'
      description = "The system is in a #{state_in_words} SCOM health state"
      
      assert Issue.find_or_init(v[:c], severity, source, identifier, description)      
    end    

    # Online Windows computers should be in SCCM
    # rule [Computer, :c, m.online? == true,
    #                     m.is_windows? == true,
    #                     m.in_sccm? == false,
    #                     m.exempt_sccm? == false] do |v|
    # 
    #   severity    = 1
    #   source      = 'Configuration'
    #   identifier  = 'Not in SCCM'
    #   description = "Online Windows computer is not in SCCM"
    # 
    #   assert Issue.find_or_init(v[:c], severity, source, identifier, description)      
    # end
    
    # Online Windows computers should be in WSUS
    rule [Computer, :c, m.online? == true,
                        m.is_windows? == true,
                        m.in_wsus? == false,
                        m.exempt_wsus? == false] do |v|

      severity    = 4
      source      = 'Configuration'
      identifier  = 'Not in WSUS'
      description = "Online Windows computer is not in WSUS"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)      
    end
    
    # Online Windows computers shouldn't have outstanding patches
    rule [Computer, :c, m.online? == true,
                        m.is_windows? == true,
                        m.exempt_wsus? == false,
                        m.us_outstanding > 0] do |v|
        
      severity    = 1
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
      
      severity    = 4
      source      = 'Configuration'
      identifier  = 'Powered off'
      description = "Computer in Production status shouldn't be powered off"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Online computers should have an owner
    rule [Computer, :c, m.online? == true,
                        m.owner? == false] do|v|
                          
      severity    = 1
      source      = 'Configuration'
      identifier  = 'Owner Required'
      description = "Computer does not have an Owner"

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
                        m.in_ldap? == false,
                        m.exempt_ldap? == false] do |v|

      severity    = 5
      source      = 'Configuration'
      identifier  = 'Not in AD'
      description = "Online Windows computer isn't in AD"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # All computers in AD should have a description
    rule [Computer, :c, m.in_ldap? == true,
                        m.exempt_ldap? == false,
                        m.description? == false] do |v|
                          
      severity    = 1
      source      = 'AD'
      identifier  = 'No description'
      description = "Computer must have a description set in AD"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
  end

end
