class Customer < ActiveRecord::Base
  usar_como_cpf :cpf
  has_many :orders, :dependent => :destroy
  
  attr_accessible :cpf, :nome, :email, :endereco, :bairro, :complemento, :cidade, :estado, 
                  :cep, :sexo, :data_nasc, :telefone, :celular
end
