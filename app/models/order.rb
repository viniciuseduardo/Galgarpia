class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  belongs_to :customer

  scope :no_action, where("orders.payment_status = 'sem acao'")
  scope :in_progress, where("orders.payment_status IN ('em andamento','enviado')")
  scope :complete, where("orders.payment_status = 'concluido'")

  STATUS = {"no acao" => "Sem Ação", "completed" => "Completo", "pending" => "Aguardando pagamento", "approved" => "Aprovado", "verifying" => "Em análise", "canceled" => "Cancelado", "refunded" => "Devolvido" }
  METHOD = {"invoice" => "Boleto", "credit_card" => "Cartão de Crédito", "pagseguro" => "PagSeguro", "online_transfer" => "Transferencia Online"}
  
  attr_accessor :pay_method, :pay_status
  attr_accessible :user_id, :total_price, :payment_method, :payment_date, :payment_status, :payment_plots, :payment_id, :line_items
  def self.find_with_product(product)
    return [] unless product
    includes(:line_items).
      where(["line_items.product_id = ?", product.id]).
      order("orders.payment_date DESC")
  end

  def checkout(transaction_id)
    self.payment_id = transaction_id
    self.save
  end

  def recalculate_price!
    self.total_price = line_items.inject(0.0){|sum, line_item| sum += line_item.price }
    save!
  end

  def pay_status
    STATUS["#{self.payment_status}"]
  end
  
  def pay_method
    METHOD["#{self.payment_method}"]
  end

  def display_name
    ActionController::Base.helpers.number_to_currency(total_price) + 
      " - Order ##{id} (#{user.nome})"
  end

end
