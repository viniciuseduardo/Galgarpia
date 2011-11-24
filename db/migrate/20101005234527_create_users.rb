class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :nome, :null => false
      t.string  :cpf, :null => false
      t.date    :data_nasc, :null => false
      t.text    :endereco, :null => false
      t.string  :sexo, :null => false
      t.string  :telefone, :null => false
      t.string  :celular
      t.string  :email, :null => false
      t.string  :password_hash, :null => false
      t.string  :password_salt
      t.integer :site_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
