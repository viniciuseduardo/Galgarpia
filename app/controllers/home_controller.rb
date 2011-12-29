class HomeController < ApplicationController
  def index
    @site = Site.find(current_site)
  end
end