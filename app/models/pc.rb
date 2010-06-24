require 'ipaddr'

class Pc < ActiveRecord::Base
  
    IP_PAD = 2147483648

    def self.find_all_sorted_by_fqdn(conditions=[])
      computers = self.find(:all,
                            :order => "computers.fqdn",
                            :conditions => conditions)
    end

    def to_label
      self.name
    end

    def health_us_outstanding
      case self.us_outstanding
        when 0 then 0
        when 1..(1.0/0) then 3
      end
    end

    def us_outstanding
      if self.us_approved == nil or self.us_pending_reboot == nil or self.us_failed == nil
        -1
      else
        self.us_approved + self.us_pending_reboot + self.us_failed
      end
    end

    def health_ep_dat
      case ep_dat_outdated
        when -(1.0/0)..0 then 0
        when 1..2 then 1
        when 3..5 then 2
        when 6..(1.0/0) then 3
      end
    end

    def name
      self.fqdn.split(".")[0].upcase if self.fqdn
    end

    def domain
      self.fqdn.split(".", 2)[1] if self.fqdn
    end

    def ip=(ip_str)
      self.ip_int = ip_to_i(ip_str)
    end

    def ip
      i_to_ip(self.ip_int)
    end


    def os_long
      [self.os_vendor, self.os_name, self.os_version, self.os_edition].join(' ')
    end

    def self.regenerate_health
      Computer.all.each do |c|
        health_array = []
        health_array << (c.issues.active.without_scom.map {|i| i.severity}.max || 0)

        scom_health = (c.issues.active.scom_only.map {|i| i.severity}.max || 0) * 0.1
        health_array << ((scom_health + 1 if scom_health > 0) || 0)
        health = health_array.max

        rank = health * 100

        rank += 1000 if (c.production? && health >= 2)

        rank += case c.aasm_current_state
          when :production_1 then  5
          when :production_2 then  4
          when :production_3 then  3
          when :nonproduction then 2
          when :unknown then       1
          else 0
        end

        c.health = health
        c.health_rank = rank
        c.save
      end
    end

  private

    def i_to_ip(int)
      IPAddr.new(int + IP_PAD, Socket::AF_INET).to_s unless int.nil?
    end

    def ip_to_i(str)
      IPAddr.new(str).to_i - IP_PAD unless str.nil?
    end
end
