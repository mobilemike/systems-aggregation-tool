# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :layout
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  ActiveScaffold.set_defaults do |c|
    c.dhtml_history = false
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
