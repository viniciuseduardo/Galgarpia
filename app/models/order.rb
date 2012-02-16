class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  belongs_to :customer
  belongs_to :site

  scope :no_action, where("orders.payment_status = 'no action'")
  scope :in_progress, where("orders.payment_status IN ('pending','verifying')")
  scope :approved, where("orders.payment_status = 'approved'")
  scope :complete, where("orders.payment_status = 'completed'")
  scope :canceled, where("orders.payment_status = 'canceled'")
  scope :refunded, where("orders.payment_status = 'refunded'")

  STATUS = {"no action" => "Sem Ação", "completed" => "Completo", "pending" => "Aguardando pagamento", "approved" => "Aprovado", "verifying" => "Em análise", "canceled" => "Cancelado", "refunded" => "Devolvido" }
  METHOD = {"invoice" => "Boleto", "credit_card" => "Cartão de Crédito", "pagseguro" => "PagSeguro", "online_transfer" => "Transferencia Online"}
  DELIVERY = { "0" => "NAO ENVIADO", "1" => "ENVIADO" }

  attr_accessor :pay_method, :pay_status
  attr_accessible :site_id, :customer_id, :total_price, :payment_method, :payment_date, :payment_status, :payment_plots, :payment_id, :line_items, 
                  :delivery_number, :delivery_date, :delivery_status, :delivery_text
                  
  before_save :change_status

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
      " - Pedido ##{id} (#{user.nome})"
  end
  
  def status_delivery
    DELIVERY["#{self.delivery_status}"]
  end
  
  private
  def change_status
    if !self.delivery_number.nil?
      self.delivery_status = 1
      Envio.enviado(self).deliver
    end
  end
end
