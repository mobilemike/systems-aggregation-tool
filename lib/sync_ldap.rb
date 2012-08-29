require 'net/ldap'

AD_DIVISOR = 10_000_000
AD_OFFSET = 11_644_473_600

def msdate_to_time(msdate)
  Time.at( (msdate[0].to_i / AD_DIVISOR) - AD_OFFSET)
end

def sync_ldap
  [['DCNAME', 'DOMAIN', 'OU=Member Servers'],
   ['DCNAME', 'DOMAIN', 'OU=Member Servers'],
   ['DCNAME', 'DOMAIN', 'OU=Member Servers'],
   ['DCNAME', 'DOMAIN', 'CN=Computers'],
   ['DCNAME', 'DOMAIN', 'CN=Computers'],
   ['DCNAME', 'DOMAIN', 'CN=Computers'],
   ['DCNAME','DOMAIN', ['OU=MemberServers','OU=MemberServers,OU=Computers,OU=FrontOffice']]].each do |domain|
    ldap = Net::LDAP.new(:host => domain[0] + "." + domain[1],
                         :port => '389',
                         :auth => {:method => :simple,
                                   :username => 'USERNAME' + '@' + domain[1],
                                   :password => 'PASSWORD'}
                         )
    
    containers = ['OU=Domain Controllers'] << domain[2]
    
    containers.flatten.each do |container|
      base = "#{container},DC=#{domain[1].split('.')[0]},DC=#{domain[1].split('.')[1]}"
      computer = Net::LDAP::Filter.eq( 'objectClass', 'computer' )
      attrs = ['dnshostname', 'description', 'canonicalname', 'lastlogontimestamp', 'notes', 'serviceprincipalname']

      ldap.search(:base => base, :filter => computer, :attributes => attrs, 
                  :return_result => false ) do |entry|

        r = Hash.new

        entry.each do |a, v|
          case a
            when :dnshostname then r["fqdn"] = v.to_s.downcase if v.to_s.match(/.*\..*\..*/)
            when :description then r["description"] = v.to_s
            when :canonicalname then r["ou"] = v.to_s[/\/(.*)\//, 1]
            when :lastlogontimestamp then r["ad_last_logon_timestamp"] = msdate_to_time(v)
            when :notes then r["notes"] = v.to_s
            when :serviceprincipalname
              r["cluster_virtual_server"] = true if v.to_s.match(/MSClusterVirtualServer/)
          end
        end

        if r["fqdn"] && !r["cluster_virtual_server"]
          r["in_ldap"] = true
          r["ad_last_logon_timestamp"] = r["ad_last_logon_timestamp"] || DateTime.new

          if domain[1] == "DOMAIN"
            if container.match(/OU=FrontOffice/)
              r["is_pci"] = true
            else
              r["is_pci"] = false
            end
          end
          
          computer = Computer.find_or_create_by_fqdn(r["fqdn"])
          computer.update_attributes(r)
        end
      end
    end
  end
end
