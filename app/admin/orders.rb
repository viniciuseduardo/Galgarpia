ActiveAdmin.register Order, :as => "Pedidos" do
  actions :index, :show, :update

  filter :id
  filter :customer_nome, :as => :string, :label => 'Name do Cliente'
  filter :customer_email, :as => :string, :label => 'Email do Cliente'  
  #filter :payment_status, :as => :select, :collection => Order::METHOD
  filter :created_at, :label => 'Data da Compra'
  filter :payment_date, :label => 'Data de Pagamento'
  filter :delivery_status, :label => 'Status Entrega'  

  scope :all, :default => true
  scope "Sem Ação", :no_action
  scope "Em Progresso", :in_progress
  scope "Completo", :complete
  scope "Cancelado", :canceled
  scope "Devolvido", :refunded

  index do
    column("ID", :sortable => :id) {|order| link_to "##{order.id} ", admin_pedido_path(order) }
    column("Data de Compra", :created_at)
    column("Status Pgto") {|order| status_tag(order.pay_status, nil, :class => order.payment_status) }
    column("Tipo de Pgto") {|order| order.pay_method }
    column("Data de Pgto", :payment_date)    
    column("Cliente"){ |order| order.customer.nome  unless  order.customer.nil? }
    column("Total") {|order| number_to_currency order.total_price }
    column("Status Envio") {|order| status_tag(order.status_delivery, nil, :class => order.status_delivery) }
  end

  show do
    panel "Dados da Compra" do
      attributes_table_for pedido do
        row("Identificador PagSeguro") { pedido.payment_id }
        row("Forma de Pagamento"){ pedido.pay_method }
        row("Numero de Parcelas"){ pedido.payment_plots } if !pedido.payment_plots.nil?        
        row("Status do Pedido"){ pedido.pay_status }
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
    panel "Dados de Envio" do    
      render :partial => "envio"
    end
    active_admin_comments
  end

  sidebar "Informação do Cliente", :only => :show do 
    attributes_table_for pedido.customer do
      if !pedido.customer.nil?
        row("Nome") { auto_link pedido.customer.nome } 
        row :email
        row("Endereço") { "#{pedido.customer.endereco}, #{pedido.customer.complemento}"}
        row :cidade
        row :estado
        row :telefone
        row :celular
      end
    end
  end
end