PAGSEGURO_ORDERS_FILE = File.join(Rails.root, "tmp", "pagseguro-#{Rails.env}.yml")
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
p "Criando Galgarpia"
texto = Faker::HTMLIpsum.p(10)
texto << Faker::HTMLIpsum.a
Site.create! :nome => "Galgarpia", :domain => "127.0.0.1", :link_afiliados => "http://www.clicklucro.com.br/sale.php?affiliate_id=101", :texto_inicial => texto
p "Criando Sites Fakes"
NB_SITES = 5
NB_SITES.times do |n|
  texto = Faker::HTMLIpsum.p(10)
  texto << Faker::HTMLIpsum.a
  Site.create! :nome => "Site #{n + 1}", :link_afiliados => "http://afiliados#{n + 1}.local/", :texto_inicial => texto
end

# Create default user
p "Criando Cliente"
Customer.create! do |u|
  u.nome = 'Vinicius Alves'
  u.email = 'vinicius@videologinc.tv'
  u.cpf = "46905226505"
  u.endereco = "Avenida Rio Branco, 156"
  u.complemento = "Sala 3320"
  u.bairro = "Centro"
  u.cidade = "Rio de Janeiro"
  u.estado = "RJ"
  u.sexo = "Masculino"
  u.data_nasc = "1986-04-12"
  u.telefone = "21 3835-4745"
  u.celular  = "21 7814-5667"
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

NB_PRODUCTS = Product.count
# Create 200 Orders
p "Criando Orders"
NB_ORDERS = 100
NB_ORDERS.times do
  order = Order.new
  order.payment_status = "no action"
  day = rand(30) + 1  
  order.created_at = day.days.ago - 1
  nb_items = 1

  product = nil
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
  FileUtils.touch(PAGSEGURO_ORDERS_FILE) unless File.exist?(PAGSEGURO_ORDERS_FILE)
  pedidos = YAML.load_file(PAGSEGURO_ORDERS_FILE) || HashWithIndifferentAccess.new
  pedidos["#{order.id}"] = {:tipo => "CP", :ref_transacao => "#{order.id}", :moeda => "BRL", :email_cobranca => "user@example.com",
              :item_id_1 => product.id, :item_descr_1 => product.title, 
              :item_valor_1 => (BigDecimal("#{product.price}") * 100).to_i, :item_quant_1 => "1"}  
  # save the file
  File.open(PAGSEGURO_ORDERS_FILE, "w+") do |file|
    file << pedidos.to_yaml
  end  
end
