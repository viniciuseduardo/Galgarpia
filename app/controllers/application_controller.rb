class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery

  private
  def current_site
    site = Site.find_by_domain(request.host)
    @_current_site ||= site.id unless site.nil?
  end
end
