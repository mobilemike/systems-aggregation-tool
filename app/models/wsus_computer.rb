class WsusComputer < ActiveRecord::Base
  belongs_to :computer
  
  def update_health
    case updates_outstanding
      when 0..1 then 1
      when 2..3 then 2
      when 4..(1.0/0) then 3
    end
  end

  def updates_outstanding
    updates_approved + updates_pending_reboot + updates_failed
  end

end
