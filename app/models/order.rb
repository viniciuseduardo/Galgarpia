class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  belongs_to :user

  scope :no_action, where("orders.payment_status = 'sem acao'")
  scope :in_progress, where("orders.payment_status IN ('em andamento','enviado')")
  scope :complete, where("orders.payment_status = 'concluido'")

  STATUS = ["sem acao", "em andamento", "enviado", "concluido"]
  METHOD = ["boleto", "cartao de credito", "cartao de debito", "transferencia"]
  def self.find_with_product(product)
    return [] unless product
    includes(:line_items).
      where(["line_items.product_id = ?", product.id]).
      order("orders.payment_date DESC")
  end

  def checkout!
    self.payment_date = Time.now
    self.save
  end

  def recalculate_price!
    self.total_price = line_items.inject(0.0){|sum, line_item| sum += line_item.price }
    save!
  end

  def state
    payment_status
  end

  def display_name
    ActionController::Base.helpers.number_to_currency(total_price) + 
      " - Order ##{id} (#{user.nome})"
  end

end
