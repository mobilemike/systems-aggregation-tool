class IssueGroup
  
  def initialize
    @issues = Issue.find(:all)
  end
  
  def all
    @issues
  end
  
end