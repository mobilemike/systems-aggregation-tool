class ComputerReport
  include Ruleby
  
  def report
    engine :engine do |e|
      r = ComputerRulebook.new(e)
    
      r.configuration_issues
    
      Computer.all.each do |c|
        e.assert c
      end
    
      e.match
      e.retrieve(Issue).each {|i| i.update_attributes(:updated_at => Time.now)}
      return true
    end
  end
  
end