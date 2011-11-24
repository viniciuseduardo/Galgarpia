class ProductsController < ApplicationController
  def index
    @products = Product.where(:site_id => current_site)
  end
  
  def show
    @product = Product.find(params[:id])
  end
end
