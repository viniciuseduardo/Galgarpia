class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :nome
      t.string :email
      t.string :cpf
      t.string :sexo      
      t.date :data_nasc
      t.string :endereco
      t.string :bairro
      t.string :complemento
      t.string :cidade
      t.string :estado
      t.string :cep
      t.string :telefone
      t.string :celular
      t.timestamps
    end
    add_index :customers, [:email, :cpf], :unique => true
    add_index :customers, :email
    add_index :customers, :cpf
  end

  def self.down
    drop_table :customers
  end
end
