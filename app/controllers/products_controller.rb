class ProductsController < ApplicationController
  before_filter :find_cart, :except => [ :show ]
  def index
    @order = PagSeguro::Order.new(@cart.id)    
    @products = Product.where(:site_id => current_site)
  end
  
  def show
    @product = Product.find(params[:id])
  end
  
  protected
  def find_cart
    @cart = session[:cart_id] ? Order.find(session[:cart_id]) : Order.new
  end  
end
