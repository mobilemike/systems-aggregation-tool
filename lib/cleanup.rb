def cleanup
  Issue.mark_old_closed
  Computer.regenerate_health
end
