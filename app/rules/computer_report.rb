class ComputerReport
  include Ruleby
  
  def report
    issues = IssueGroup.new
    
    engine :enging do |e|
      r = ComputerRulebook.new(e)
    
      r.configuration_issues
    
      Computer.all.each do |c|
        e.assert c
      end
    
      e.match
      e.retrieve(Issue).each {|i| i.save}
      return true
    end
  end
  
end