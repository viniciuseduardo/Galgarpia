# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#

# Create default admin user
AdminUser.delete_all
AdminUser.create! do |a|
  a.email = 'admin@galgarpia.com'
  a.password = a.password_confirmation = 'q1w2e3'
end

# Create default user
User.delete_all
User.create! do |u|
  u.nome = 'Vinicius Alves'
  u.email = 'vinicius@videologinc.tv'
  u.cpf = "46905226505"
  u.endereco = "Avenida Rio Branco, 156, Sala 3320, Centro, Rio de Janeiro, RJ"
  u.sexo = "Masculino"
  u.data_nasc = "1986-04-12"
  u.telefone = "21 3835-4745"
  u.celular  = "21 7814-5667"
  u.password = u.password_confirmation = 'qawsedrf'
end

#Create Sites
NB_SITES = 6
NB_SITES.times do |n|
  Site.create! :nome => "Site #{n + 1}", :url => "http://vend#{n + 1}.local/", :link_afiliados => "http://afiliados#{n + 1}.local/"
end

# Load each product from the yaml file
Product.delete_all
YAML.load_file(File.expand_path("../seeds/products.yml", __FILE__)).each do |product|
  site_id = rand(NB_SITES - 1) + 1
  site = Site.find(site_id)
  Product.create! product.merge(:site => site)
end

NB_PRODUCTS = Product.count

# Create 20 Orders
Order.delete_all
NB_ORDERS = 20
NB_ORDERS.times do
  user = User.first
  order = user.orders.create
  order.payment_method = Order::METHOD[rand(Order::METHOD.length)]
  order.payment_status = Order::STATUS[rand(Order::STATUS.length)]
  day = rand(30) + 1  
  order.created_at = day.days.ago - 1
  if order.payment_status == "concluido"
    order.payment_date = day.days.ago
  end  
  if order.payment_method == "cartao de credito"
    order.payment_plots = rand(5) + 1
  end
  nb_items = 1

  nb_items.times do
    product_id = rand(NB_PRODUCTS - 1) + 1
    product = Product.find(product_id)
    LineItem.create do |l|
      l.order = order
      l.product = product
      l.price = product.price
    end
  end

  order.recalculate_price!
end
