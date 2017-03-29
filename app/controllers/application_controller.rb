# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # put Access Control Unit to monitor upon request
  before_action { ACU::monitor request }

end