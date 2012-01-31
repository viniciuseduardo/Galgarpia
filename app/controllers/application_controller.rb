class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery
  before_filter :current_site

  private
  def current_site
    site = Site.find_by_domain(request.host)
    @_current_site ||= site unless site.nil?
  end
end
