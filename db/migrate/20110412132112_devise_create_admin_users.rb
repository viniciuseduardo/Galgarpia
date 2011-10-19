class DeviseCreateAdminUsers < ActiveRecord::Migration
  def self.up
    create_table(:admin_users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.timestamps
    end

    # Create a default admin user
    AdminUser.create!(:email => 'admin@galgarpia.com', :password => 'q1w2e3', :password_confirmation => 'q1w2e3')

    add_index :admin_users, :email,                :unique => true
    add_index :admin_users, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :admin_users
  end
end
