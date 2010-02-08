class ComputerRulebook < Ruleby::Rulebook

  def configuration_issues
    
    # Online Windows computers should be in EPO
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.in_epo? == false] do |v|
      puts "#{v[:c].name}: Online Windows computers should be in EPO"
    end
    
    # Production computers should have a very recent DAT
    rule [Computer, :c, m.production? == true,
                        m.ep_dat_outdated > 1] do |v|
      puts "#{v[:c].name}: Production computers shouldn't have a DAT that's #{v[:c].ep_dat_outdated} days old"
    end
    
    # Nonproduction computers should have a relativley recent DAT
    rule [Computer, :c, m.nonproduction? == true,
                        m.ep_dat_outdated > 5] do |v|
      puts "#{v[:c].name}: Nonproduction computers shouldn't have a DAT that's #{v[:c].ep_dat_outdated} days old"
    end
    
    # # Production computers that don't run ESX should be in Avamar
    # rule [Computer, :c, m.production? == true,
    #                     m.is_esx? == false,
    #                     m.in_avamar? == false] do |v|
    #   puts "#{v[:c].name}: Production computers that don't run ESX should be in Avamar"
    # end
    
    # Production virtual guests should be in Akorri
    rule [Computer, :c, m.production? == true,
                        m.is_guest_of_esx? == true,
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
                        m.is_guest_of_esx? == true,
                        m.power? == false] do |v|
      puts "#{v[:c].name}: Production virtual guests shouldn't be powered off"
    end
    
    # Decommissioned computers shouldn't be reported in systems
    
    # Online Windows computers shouldn't have outstanding patches
    rule [Computer, :c, m.production? == true || m.nonproduction? == true,
                        m.is_windows? == true,
                        m.us_outstanding > 0] do |v|
      puts "#{v[:c].name}: Online omputers shouldn't have " +
        ActionController::Base.helpers.pluralize(v[:c].us_outstanding, 'patch') +
        " outstanding in WSUS"
    end
    
  end

end