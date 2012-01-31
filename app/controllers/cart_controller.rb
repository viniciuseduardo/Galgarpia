class CartController < ApplicationController
  respond_to :html, :json, :js
  before_filter :find_cart, :except => [ :confirm ]
  skip_before_filter :verify_authenticity_token

  def add
    @cart.payment_status = "no action"
    @cart.save if @cart.new_record?
    session[:cart_id] = @cart.id
    product = Product.find(params[:id])
    @cart.line_items.delete_all    
    @cart.line_items.build :order => @cart, :product => product, :price => product.price
    @cart.recalculate_price!

    @order = PagSeguro::Order.new(@cart.id)
    @cart.line_items.each do |line_item|
      @order.add :id => line_item.product.id, :price => line_item.price, :description => line_item.product.title
    end    
    respond_with(@order)
  end

  def remove
    item = @cart.line_items.find(params[:id])
    item.destroy
    @cart.recalculate_price!
    flash[:notice] = "Item removed from cart"
    redirect_to '/cart'
  end

  def checkout
    if session[:cart_id]
      @cart.checkout(params["transaction_id"])
      session.delete(:cart_id)
      flash[:notice] = "Pedido efetuado com sucesso."
    else
      redirect_to root_path
    end
  end

  def confirm
    return unless request.post?
    pagseguro_notification do |notification|
      @customer = Customer.find_by_email(notification.buyer[:email])
      if @customer.nil?
        Rails.logger.info notification.buyer.inspect
        @customer = Customer.new
        @customer.email       = notification.buyer[:email]
        @customer.nome        = notification.buyer[:name]
        @customer.endereco    = "#{notification.buyer[:address][:street]},#{notification.buyer[:address][:number]}"
        @customer.complemento = notification.buyer[:address][:complements]
        @customer.bairro      = notification.buyer[:address][:neighbourhood]
        @customer.cidade      = notification.buyer[:address][:city]
        @customer.estado      = notification.buyer[:address][:state]
        @customer.cep         = notification.buyer[:address][:postal_code]
        @customer.telefone    = "#{notification.buyer[:phone][:area_code]} #{notification.buyer[:phone][:number]}"
        @customer.save
      end
      @order = Order.find(notification.params["Referencia"])
      @order.customer_id = @customer.id
      @order.payment_status = notification.status
      @order.payment_method = notification.payment_method
      @order.payment_date = notification.processed_at
      @order.payment_id = notification.params["TransacaoID"]
      @order.save
    end
    render :nothing => true
  end

  protected
  def find_cart
    Rails.logger.info session[:cart_id]
    @cart = session[:cart_id] ? Order.find(session[:cart_id]) : Order.new
  end

end
