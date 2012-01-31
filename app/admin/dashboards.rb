ActiveAdmin::Dashboards.build do

  section "Ultimas Compras", :priority => 1 do
    table_for Order.complete.order('id desc').limit(10) do
      column("ID")   {|order| link_to(order.id, admin_pedido_path(order))}
      column("Status") {|order| status_tag(order.pay_status, nil, :class => order.payment_status) }
      column("Cliente") {|order| link_to(order.customer.nome, admin_cliente_path(order.customer)) } 
      column("Total")   {|order| number_to_currency order.total_price                       } 
    end
  end

  section "Ultimos Clientes", :priority => 2 do
    table_for Customer.order('id desc').limit(10).each do |customer|
      column(:email) {|customer| link_to(customer.email, admin_cliente_path(customer)) }
    end
  end
end