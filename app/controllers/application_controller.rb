# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :layout
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  ActiveScaffold.set_defaults do |c|
    c.dhtml_history = false
  end
  
  HEALTH_DESCRIPTION = "System Health
  <table style=\"width: 100px\">
    <tr><td><img src=\"#{ActionController::Base.relative_url_root}/images/tomato_16.gif\" /></td><td>Severe State</td></tr>
    <tr><td><img src=\"#{ActionController::Base.relative_url_root}/images/onion_16.gif\" /></td><td>Warning State</td></tr>
    <tr><td><img src=\"#{ActionController::Base.relative_url_root}/images/carrot_tomato_22.gif\" /></td><td>Severe Alert</td></tr>
    <tr><td><img src=\"#{ActionController::Base.relative_url_root}/images/carrot_onion_22.gif\" /></td><td>Warning Alert</td></tr>
    <tr><td><img src=\"#{ActionController::Base.relative_url_root}/images/carrot_blue_16.gif\" /></td><td>Info Alert</td></tr>
    <tr><td><img src=\"#{ActionController::Base.relative_url_root}/images/cabbage_16.gif\" /></td><td>Normal</td></tr>
  </table>    
  "

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
