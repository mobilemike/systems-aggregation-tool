module IssuesHelper

  def age_column issue
    distance_of_time_in_words(issue.updated_at, Time.now)
  end
  
  def description_column issue
    truncate_with_tip(issue.description || 'None', 75)
  end
  
end