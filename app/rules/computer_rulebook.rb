class ComputerRulebook < Ruleby::Rulebook

  def configuration_issues
    
    # Online Windows computers should be in EPO
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.in_epo? == false] do |v|
                          
      severity = 2
      source   = 'EPO'
      identifier = 'Not in EPO'
      description     = "Windows computer is online, but not in EPO"
      
      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Computers in EPO should report their current DAT version accurately
    rule [Computer, :c, m.ep_dat_outdated > 5000] do |v|
      
      severity = 2
      source   = 'EPO'
      identifier = 'DAT not reporting'
      description     = "Computer is not reporting it's DAT version accurately"
      
      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Production computers should have a very recent DAT
    rule [Computer, :c, m.production? == true,
                        m.ep_dat_outdated > 1,
                        m.ep_dat_outdated < 5000] do |v|
                          
      severity = 2
      source   = 'EPO'
      identifier = 'DAT out of date'
      description     = "Production computer's DAT is #{v[:c].ep_dat_outdated} days old"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Nonproduction, powered on computers should have a relativley recent DAT
    rule [Computer, :c, m.nonproduction? == true,
                        m.power?.not== false,
                        m.ep_dat_outdated > 5,
                        m.ep_dat_outdated < 5000] do |v|
                          
      severity = 2
      source   = 'EPO'
      identifier = 'DAT out of date'
      description     = "Nonproduction computer's DAT is #{v[:c].ep_dat_outdated} days old"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # # Production computers that don't run ESX should be in Avamar
    # rule [Computer, :c, m.production? == true,
    #                     m.is_esx? == false,
    #                     m.in_avamar? == false] do |v|
    #   puts "#{v[:c].name}: Production computers that don't run ESX should be in Avamar"
    # end
    
    # Production virtual guests should be in Akorri
    rule [Computer, :c, m.production? == true,
                        m.in_esx? == true,
                        m.in_akorri? == false,] do |v|

      severity = 2
      source   = 'Akorri'
      identifier = 'Not in Akorri'
      description     = "Production ESX guest isn't in Akorri"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Online Windows computers should be in WSUS
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.in_wsus? == false] do |v|

      severity = 2
      source   = 'WSUS'
      identifier = 'Not in WSUS'
      description     = "Windows computer is online, but not in WSUS"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)      
    end
    
    # Online Windows computers shouldn't have outstanding patches
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.us_outstanding > 0] do |v|
        
      severity = 2
      source   = 'WSUS'
      identifier = 'Pending patches'
      description     = "Computer has " +
                 ActionController::Base.helpers.pluralize(v[:c].us_outstanding, 'patch') +
                 " outstanding in WSUS"

       assert Issue.find_or_init(v[:c], severity, source, identifier, description)        
    end
    
    # All computers in AD should have a description
    rule [Computer, :c, m.in_ldap? == true,
                        m.description == nil] do |v|
                          
      severity = 2
      source   = 'AD'
      identifier = 'No description'
      description     = "Computer must have a description set in AD"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Archived computers shouldn't be powered on
    rule [Computer, :c, m.archived? == true,
                        m.power? == true] do |v|
      
      severity = 2
      source   = 'Status'
      identifier = 'Powered on'
      description     = "Computer in Archived status shouldn't be powered on"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Production virtual guests shouldn't be powered off
    rule [Computer, :c, m.production? == true,
                        m.in_esx? == true,
                        m.power? == false] do |v|
      
      severity = 2
      source   = 'Status'
      identifier = 'Powered off'
      description     = "Computer in Production status shouldn't be powered off"

      assert Issue.find_or_init(v[:c], severity, source, identifier, description)
    end
    
    # Decommissioned computers shouldn't be reported in systems
    
  end

end