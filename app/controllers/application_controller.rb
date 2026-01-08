class ApplicationController < ActionController::Base
  include Availability

  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
end
