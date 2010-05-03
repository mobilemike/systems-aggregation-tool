module IssuesHelper

  def age_column issue
    distance_of_time_in_words(issue.created_at, Time.now)
  end
  
  def severity_column issue
    if issue.source = 'SCOM'
      food_icon((issue.severity * 0.1) + 1)
    else
      food_icon(issue.severity)
    end
  end
  
  def identifier_column issue
    truncate_with_tip(issue.identifier || '-', 50)
  end
  
  def description_column issue
    truncate_with_tip(issue.description || '-', 50)
  end
  
end