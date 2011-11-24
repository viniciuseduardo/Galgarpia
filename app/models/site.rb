class Site < ActiveRecord::Base
  has_many :products, :dependent => :destroy
  has_many :users, :dependent => :nullify
  
  attr_accessible :nome, :domain, :link_afiliados, :products, :users
  
  def display_name
    nome
  end
end