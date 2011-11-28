# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#
p "Truncando Tabelas"
config = ActiveRecord::Base.configurations[RAILS_ENV]
ActiveRecord::Base.establish_connection
ActiveRecord::Base.connection.tables.each do |table|
  p "TRUNCATE #{table}"
  if table != "schema_migrations"
    ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
  end
end
# Create default admin user
p "Criando Admin"
AdminUser.create! do |a|
  a.email = 'admin@galgarpia.com'
  a.password = a.password_confirmation = 'q1w2e3'
end

#Create Sites
p "Criando Sites"
NB_SITES = 6
NB_SITES.times do |n|
  Site.create! :nome => "Site #{n + 1}", :link_afiliados => "http://afiliados#{n + 1}.local/"
end

# Create default user
p "Criando Usuario"
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
  u.site_id = 1
end


# Load each product from the yaml file
p "Criando Produtos"
i = 1
YAML.load_file(File.expand_path("../seeds/products.yml", __FILE__)).each do |product|
  site = Site.find(i)
  Product.create! product.merge(:site => site)
  i += 1
end

# NB_PRODUCTS = Product.count
# # Create 20 Orders
# p "Criando Orders"
# NB_ORDERS = 20
# NB_ORDERS.times do
#   user = User.first
#   order = user.orders.create
#   order.payment_method = Order::METHOD[rand(Order::METHOD.length)]
#   order.payment_status = Order::STATUS[rand(Order::STATUS.length)]
#   day = rand(30) + 1  
#   order.created_at = day.days.ago - 1
#   if order.payment_status == "concluido"
#     order.payment_date = day.days.ago
#   end  
#   if order.payment_method == "cartao de credito"
#     order.payment_plots = rand(5) + 1
#   end
#   nb_items = 1
# 
#   nb_items.times do
#     product_id = rand(NB_PRODUCTS - 1) + 1
#     product = Product.find(product_id)
#     LineItem.create do |l|
#       l.order = order
#       l.product = product
#       l.price = product.price
#     end
#   end
# 
#   order.recalculate_price!
# end
