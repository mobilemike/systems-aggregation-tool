class ComputerReport
  include Ruleby
  
  def report
    engine :enging do |e|
      r = ComputerRulebook.new(e)
    
      r.configuration_issues
    
      Computer.all.each do |c|
        e.assert c
      end
    
      e.match
      return true
    end
  end
  
end