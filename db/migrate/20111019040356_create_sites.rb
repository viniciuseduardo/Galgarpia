class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :domain
      t.string :nome
      t.string :alias
      t.text :texto_inicial
      t.string :link_afiliados
      t.timestamps
    end
    add_index :sites, :domain
  end

  def self.down
    drop_table :sites
  end
end