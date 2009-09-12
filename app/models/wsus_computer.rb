class WsusComputer < ActiveRecord::Base
  belongs_to :computer
  
  def update_health
    case updates_outstanding
      when 0 then 1
      when 1..(1.0/0) then 3
    end
  end

  def updates_outstanding
    updates_approved + updates_pending_reboot + updates_failed
  end

  def to_label
    updates_outstanding
  end

end

