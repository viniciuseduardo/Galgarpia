ActiveAdmin.register Order do
  actions :index, :show

  filter :id
  filter :user_nome, :as => :string, :label => 'Customer Name'
  filter :user_cpf, :as => :string, :label => 'Customer CPF'  
  filter :created_at
  filter :payment_method
  filter :payment_date
  filter :payment_status

  scope :all, :default => true
  scope :no_action  
  scope :in_progress
  scope :complete

  index do
    column("Order", :sortable => :id) {|order| link_to "##{order.id} ", admin_order_path(order) }
    column("State")                   {|order| status_tag(order.payment_status) }
    column("Order Date", :created_at)
    column("Payment Date", :payment_date)
    column("Customer", :user, :sortable => :user_id)
    column("Total")                   {|order| number_to_currency order.total_price }
  end

  show do
    panel "Invoice" do
      attributes_table_for order do
        row :payment_id       
        row :pay_method
        row :payment_status
        row :payment_date
        row :payment_plots
      end
      table_for(order.line_items) do |t|
        t.column("Product") {|item| auto_link item.product        }
        t.column("Price")   {|item| number_to_currency item.price }
        tr :class => "odd" do
          td "Total:", :style => "text-align: right;"
          td number_to_currency(order.total_price)
        end
      end
    end

    active_admin_comments
  end

  sidebar :customer_information, :only => :show do
    attributes_table_for order.user do
      row("User") { auto_link order.user }
      row :email
      row :telefone
      row :celular
    end
  end
end
