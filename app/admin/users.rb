ActiveAdmin.register Customer, :as => "Customer" do
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
    panel "Order History" do
      table_for(customer.orders) do
        column("Order", :sortable => :id) {|order| link_to "##{order.id}", admin_order_path(order) }
        column("State")                   {|order| status_tag(order.state) }
        column("Date", :sortable => :checked_out_at){|order| pretty_format(order.created_at) }
        column("Total")                   {|order| number_to_currency order.total_price }
      end
    end
    active_admin_comments
  end

  sidebar "Customer Details", :only => :show do
    attributes_table_for customer, :nome, :email, :telefone, :celular, :created_at, :site
  end

  sidebar "Order History", :only => :show do
    attributes_table_for customer do
      row("Total Orders") { customer.orders.complete.count }
      row("Total Value") { number_to_currency customer.orders.complete.sum(:total_price) }
    end
  end
end
