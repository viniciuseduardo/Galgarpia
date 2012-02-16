ActiveAdmin.register AdminUser, :as => "Usuarios" do
  index do
      column :email
      column :current_sign_in_at
      column :last_sign_in_at
      column :sign_in_count
      default_actions
  end
  form do |f|
    f.inputs "Dados usuario" do
      f.input :email
      f.input :password
      f.input :password_confirmation            
    end
    f.buttons
  end  
end
