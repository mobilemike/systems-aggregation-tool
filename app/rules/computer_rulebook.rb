class ComputerRulebook < Ruleby::Rulebook

  def configuration_issues
    
    # Online Windows computers should be in EPO
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.in_epo? == false] do |v|
                          
      category = 'Warning'
      source   = 'EPO'
      text     = "Windows computer is online, but not in EPO"
      
      assert Issue.find_or_init(v[:c], category, source, text)
    end
    
    # Computers in EPO should report their current DAT version accurately
    rule [Computer, :c, m.ep_dat_outdated > 5000] do |v|
      
      category = 'Warning'
      source   = 'EPO'
      text     = "Computer is not reporting it's DAT version accurately"
      
      assert Issue.find_or_init(v[:c], category, source, text)
    end
    
    # Production computers should have a very recent DAT
    rule [Computer, :c, m.production? == true,
                        m.ep_dat_outdated > 1,
                        m.ep_dat_outdated < 5000] do |v|
                          
      category = 'Warning'
      source   = 'EPO'
      text     = "Production computer's DAT is #{v[:c].ep_dat_outdated} days old"

      assert Issue.find_or_init(v[:c], category, source, text)
    end
    
    # Nonproduction, powered on computers should have a relativley recent DAT
    rule [Computer, :c, m.nonproduction? == true,
                        m.power?.not== false,
                        m.ep_dat_outdated > 5,
                        m.ep_dat_outdated < 5000] do |v|
                          
      category = 'Warning'
      source   = 'EPO'
      text     = "Nonproduction computer's DAT is #{v[:c].ep_dat_outdated} days old"

      assert Issue.find_or_init(v[:c], category, source, text)

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

      category = 'Warning'
      source   = 'Akorri'
      text     = "Production ESX guest isn't in Akorri"

      assert Issue.find_or_init(v[:c], category, source, text)
      
    end
    
    # Online Windows computers should be in WSUS
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.in_wsus? == false] do |v|

      category = 'Warning'
      source   = 'WSUS'
      text     = "Windows computer is online, but not in WSUS"

      assert Issue.find_or_init(v[:c], category, source, text)
      
    end
    
    # Online Windows computers shouldn't have outstanding patches
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.us_outstanding > 0] do |v|
        
      category = 'Warning'
      source   = 'WSUS'
      text     = "Computer has " +
                 ActionController::Base.helpers.pluralize(v[:c].us_outstanding, 'patch') +
                 " outstanding in WSUS"

      assert Issue.find_or_init(v[:c], category, source, text)
        
    end
    
    # All computers in AD should have a description
    rule [Computer, :c, m.in_ldap? == true,
                        m.description == nil] do |v|
                          
      category = 'Warning'
      source   = 'AD'
      text     = "Computer must have a description set in AD"

      assert Issue.find_or_init(v[:c], category, source, text)
    end
    
    # Archived computers shouldn't be powered on
    rule [Computer, :c, m.archived? == true,
                        m.power? == true] do |v|
      
      category = 'Warning'
      source   = 'Status'
      text     = "Computer in Archived status shouldn't be powered on"

      assert Issue.find_or_init(v[:c], category, source, text)
    end
    
    # Production virtual guests shouldn't be powered off
    rule [Computer, :c, m.production? == true,
                        m.in_esx? == true,
                        m.power? == false] do |v|
      
      category = 'Warning'
      source   = 'Status'
      text     = "Computer in Production status shouldn't be powered off"

      assert Issue.find_or_init(v[:c], category, source, text)
    end
    
    # Decommissioned computers shouldn't be reported in systems
    
  end

end