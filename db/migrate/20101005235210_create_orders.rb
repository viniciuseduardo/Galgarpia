class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.decimal :total_price, :precision => 8, :scale => 2, :default => 0      
      t.string :payment_method
      t.datetime :payment_date
      t.string  :payment_status, :default => "sem acao"
      t.integer :payment_plots
      t.string :payment_id
      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :payment_date
    add_index :orders, :payment_method
    add_index :orders, :payment_status
  end

  def self.down
    drop_table :orders
  end
end
