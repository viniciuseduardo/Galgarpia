class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :site_id      
      t.integer :customer_id
      t.decimal :total_price, :precision => 8, :scale => 2, :default => 0      
      t.string :payment_method
      t.datetime :payment_date
      t.string  :payment_status
      t.integer :payment_plots
      t.string :payment_id
      t.string :delivery_number
      t.datetime :delivery_date 
      t.integer :delivery_status, :default => 0
      t.string :delivery_text
      t.timestamps
    end
    add_index :orders, :site_id
    add_index :orders, :customer_id
    add_index :orders, :payment_id    
    add_index :orders, :payment_date
    add_index :orders, :payment_method
    add_index :orders, :payment_status
    add_index :orders, :delivery_status
    add_index :orders, :delivery_number
    execute("ALTER TABLE orders AUTO_INCREMENT = 1200")
  end

  def self.down
    drop_table :orders
  end
end
