ActiveAdmin.register Order, :as => "Pedidos" do
  actions :index, :show

  filter :id
  filter :customer_nome, :as => :string, :label => 'Name do Cliente'
  filter :customer_cpf, :as => :string, :label => 'CPF do Cliente'  
  filter :created_at
  filter :payment_date

  scope :all, :default => true
  scope "Sem Ação", :no_action
  scope "Em Progresso", :in_progress
  scope "Completo", :complete
  scope "Cancelado", :canceled
  scope "Devolvido", :refunded

  index do
    column("ID", :sortable => :id) {|order| link_to "##{order.id} ", admin_pedido_path(order) }
    column("Status") {|order| status_tag(order.pay_status, nil, :class => order.payment_status) }
    column("Data de Compra", :created_at)
    column("Data de Pagamento", :payment_date)
    column("Cliente", :customer, :sortable => :customer_id)
    column("Total") {|order| number_to_currency order.total_price }
  end

  show do
    panel "Invoice" do
      attributes_table_for pedido do
        row("Identificador PagSeguro") { pedido.payment_id }
        row("Forma de Pagamento"){ pedido.pay_method }
        row("Numero de Parcelas"){ pedido.payment_plots } if !pedido.payment_plots.nil?        
        row("Status do Pedido"){ pedido.payment_status }
        row("Data Pagamento"){ pedido.payment_date }
        row("Ultima Atualização"){ pedido.updated_at }        
      end
      table_for(pedido.line_items) do |t|
        t.column("Produto") {|item| auto_link item.product        }
        t.column("Valor")   {|item| number_to_currency item.price }
        tr :class => "odd" do
          td "Total:", :style => "text-align: right;"
          td number_to_currency(pedido.total_price)
        end
      end
    end

    active_admin_comments
  end

  sidebar "Informação do Cliente", :only => :show do 
    attributes_table_for pedido.customer do
      if !pedido.customer.nil?
        row("Nome") { auto_link pedido.customer } 
        row :email
        row :telefone
        row :celular
      end
    end
  end
end