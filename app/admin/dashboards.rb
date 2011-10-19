ActiveAdmin::Dashboards.build do

  section "Recent Order", :priority => 1 do
    table_for Order.complete.order('id desc').limit(10) do
      column("Order")   {|order| link_to(order.id, admin_order_path(order))}
      column("State")   {|order| status_tag(order.state)                                   } 
      column("Customer"){|order| link_to(order.user.email, admin_customer_path(order.user)) } 
      column("Total")   {|order| number_to_currency order.total_price                       } 
    end
  end

  section "Recent Customers", :priority => 2 do
    table_for User.order('id desc').limit(10).each do |customer|
      column(:email)    {|customer| link_to(customer.email, admin_customer_path(customer)) }
    end
  end
end