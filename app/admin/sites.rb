ActiveAdmin.register Site do
  actions :index, :show

  filter :nome
  
  index do
    column("Nome", :sortable => :nome) {|site| link_to "##{site.nome} ", admin_site_path(site) }
    column :url
    column :link_afiliados
  end
  
  show do
    panel "Products" do
      table_for(site.products) do |t|
        t.column("Product")     {|product| auto_link product }
        t.column("Price")       {|product| number_to_currency product.price }
        t.column("Total Sold")  {|product| Order.find_with_product(product).count.to_s }
        t.column("Total Sales Value"){|product| number_to_currency LineItem.where(:product_id => product.id).sum(:price) }
      end
    end

    active_admin_comments
  end  
end
