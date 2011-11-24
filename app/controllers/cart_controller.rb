class CartController < ApplicationController

  before_filter :login_required, :except => [ :confirm ]
  before_filter :find_cart, :except => [ :confirm ]
  skip_before_filter :verify_authenticity_token
  
  
  def show
    # Instanciando o objeto para geracao do formulario
    @order = PagSeguro::Order.new(@cart.id)

    # adicionando os produtos do pedido ao objeto do formulario
    @cart.line_items.each do |line_item|
      # Estes sao os atributos necessarios. Por padrao, peso (:weight) eh definido para 0,
      # quantidade eh definido como 1 e frete (:shipping) eh definido como 0.
      @order.add :id => line_item.product.id, :price => line_item.price, :description => line_item.product.title
    end
    @order.billing = {
        :name                  => @cart.user.nome,
        :email                 => @cart.user.email,
        :phone_number          => @cart.user.telefone
    }
  end

  def add
    @cart.save if @cart.new_record?
    session[:cart_id] = @cart.id
    product = Product.find(params[:id])
    LineItem.create! :order => @cart, :product => product, :price => product.price
    @cart.recalculate_price!
    flash[:notice] = "Item added to cart!"
    redirect_to '/cart'
  end

  def remove
    item = @cart.line_items.find(params[:id])
    item.destroy
    @cart.recalculate_price!
    flash[:notice] = "Item removed from cart"
    redirect_to '/cart'
  end

  def checkout
    @site = Site.find(current_site)
    @cart.checkout!
    session.delete(:cart_id)
    flash[:notice] = "Pedido efetuado com sucesso."
  end

  def confirm
    return unless request.post?
    pagseguro_notification do |notification|
      Rails.logger.info notification.params["TransacaoID"]
      @order = Order.find(notification.params["Referencia"])
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
    @cart = session[:cart_id] ? Order.find(session[:cart_id]) : current_user.orders.build
  end

end
