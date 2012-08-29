require 'net/ldap'

AD_DIVISOR = 10_000_000
AD_OFFSET = 11_644_473_600
START_OF_TIME = "1000-01-01 00:00:00"

def msdate_to_time(msdate)
  Time.at( (msdate[0].to_i / AD_DIVISOR) - AD_OFFSET)
end

def sync_ldap
  [['DCNAME', 'DOMAIN', ['OU=Workstations,OU=Computers,OU=Accounts', 'OU=Laptops,OU=Computers,OU=Accounts',
                               'OU=Kiosks,OU=Computers,OU=Accounts', 'OU=Computers,OU=Lab']],
   ['DCNAME', 'DOMAIN', ['OU=Workstations,OU=Computers,OU=Accounts', 'OU=Laptops,OU=Computers,OU=Accounts',
                             'OU=Kiosks,OU=Computers,OU=Accounts', 'OU=Computers,OU=Lab']],
   ['DCNAME','DOMAIN', ['OU=Laptops,OU=Computers,OU=FrontOffice',
                               'OU=Workstations,OU=Computers,OU=FrontOffice',
                               'OU=Laptops,OU=Computers,OU=BackOffice',
                               'OU=Workstations,OU=Computers,OU=BackOffice']]].each do |domain|
    ldap = Net::LDAP.new(:host => domain[0] + "." + domain[1],
                         :port => '389',
                         :auth => {:method => :simple,
                                   :username => 'USERNAME' + '@' + domain[1],
                                   :password => 'PASSWORD'}
                         )

    domain[2].each do |container|
      base = "#{container},DC=#{domain[1].split('.')[0]},DC=#{domain[1].split('.')[1]}"
      computer = Net::LDAP::Filter.eq( 'objectClass', 'computer' )
      attrs = ['dnshostname', 'canonicalname', 'lastlogontimestamp']

      ldap.search( :base => base, :filter => computer, :attributes => attrs, 
                   :return_result => false ) do |entry|
        r = Hash.new
    
        entry.each do |a, v|
          case a
            when :dnshostname then r["fqdn"] = v.to_s.downcase if v.to_s.match(/.*\..*\..*/)
            when :canonicalname then r["ou"] = v.to_s[/\/(.*)\//, 1]
            when :lastlogontimestamp then r["ad_last_logon_timestamp"] = msdate_to_time(v)
          end
        end

        if r["fqdn"]
          r["in_ldap"] = true
          r["ad_last_logon_timestamp"] = r["ad_last_logon_timestamp"] || START_OF_TIME
          r["is_pci"] = true if container.match(/OU=FrontOffice/)
          
          
          case domain[1]
            when "reitmr.local"
              r["company"] = "RMR"
            when "5sqc.local"
              r["company"] = "Five Star"
            when "sonesta.local"
              r["company"] = "Sonesta"
              if container.match(/OU=FrontOffice/)
                r["is_pci"] = true
              else
                r["is_pci"] = false
              end
          end
          
          pc = Pc.find_or_create_by_fqdn(r["fqdn"])
          pc.update_attributes(r)
        end
      end
    end
  end
end
