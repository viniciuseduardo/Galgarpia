ActiveAdmin.register Customer, :as => "Cliente" do
  filter :nome
  filter :email
  filter :cpf  
  
  index do
      column("Email"){ |customer| auto_link customer }
      column :nome
      column :cpf
      column :endereco
      column :telefone
      column :celular
  end

  show :title => :nome do
    panel "Histórico" do
      table_for(cliente.orders) do
        column("ID", :sortable => :id) {|order| link_to "##{order.id}", admin_pedido_path(order) }
        column("Status") {|order| status_tag(order.pay_status, nil, :class => order.payment_status) }
        column("Data de Compra", :created_at)
        column("Forma de Pagamento") {|order| order.pay_method }
        column("Total") {|order| number_to_currency order.total_price }
      end
    end
    active_admin_comments
  end

  sidebar "Customer Details", :only => :show do
    attributes_table_for cliente, :nome, :email, :telefone, :celular, :created_at
  end

  sidebar "Order History", :only => :show do
    attributes_table_for cliente do
      row("Total Orders") { cliente.orders.complete.count }
      row("Total Value") { number_to_currency cliente.orders.complete.sum(:total_price) }
    end
  end
end
