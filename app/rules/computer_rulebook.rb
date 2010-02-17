class ComputerRulebook < Ruleby::Rulebook

  def configuration_issues
    
    # Online Windows computers should be in EPO
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.in_epo? == false] do |v|
      puts "#{v[:c].name}: Online Windows computers should be in EPO"
    end
    
    # Computers in EPO should report their current DAT version accurately
    rule [Computer, :c, m.ep_dat_outdated > 5000] do |v|
      puts "#{v[:c].name}: Computers in EPO should report their current DAT version accurately"
    end
    
    # Production computers should have a very recent DAT
    rule [Computer, :c, m.production? == true,
                        m.ep_dat_outdated > 1,
                        m.ep_dat_outdated < 5000] do |v|
      puts "#{v[:c].name}: Production computers shouldn't have a DAT that's #{v[:c].ep_dat_outdated} days old"
    end
    
    # Nonproduction, powered on computers should have a relativley recent DAT
    rule [Computer, :c, m.nonproduction? == true,
                        m.power?.not== false,
                        m.ep_dat_outdated > 5,
                        m.ep_dat_outdated < 5000] do |v|
      puts "#{v[:c].name}: Nonproduction, powered on computers shouldn't have a DAT that's #{v[:c].ep_dat_outdated} days old"
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
      puts "#{v[:c].name}: Production virtual guests should be in Akorri"
    end
    
    # Online Windows computers should be in WSUS
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.in_wsus? == false] do |v|
      puts "#{v[:c].name}: Online Windows computers should be in WSUS"
    end
    
    # Archived computers shouldn't be powered on
    rule [Computer, :c, m.archived? == true,
                        m.power? == true] do |v|
      puts "#{v[:c].name}: Archived computers shouldn't be powered on"
    end
    
    # Production virtual guests shouldn't be powered off
    rule [Computer, :c, m.production? == true,
                        m.in_esx? == true,
                        m.power? == false] do |v|
      puts "#{v[:c].name}: Production virtual guests shouldn't be powered off"
    end
    
    # Decommissioned computers shouldn't be reported in systems
    
    # Online Windows computers shouldn't have outstanding patches
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.us_outstanding > 0] do |v|
      puts "#{v[:c].name}: Online computers shouldn't have " +
        ActionController::Base.helpers.pluralize(v[:c].us_outstanding, 'patch') +
        " outstanding in WSUS"
    end
    
    # All computers in AD should have a description
    rule [Computer, :c, m.in_ldap? == true,
                        m.description == nil] do |v|
      puts "#{v[:c].name}: All computers in AD should have a description"
    end
    
  end

end