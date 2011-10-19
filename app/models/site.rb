class Site < ActiveRecord::Base
  has_many :products, :dependent => :destroy
  
  attr_accessible :nome, :url, :link_afiliados
  
  def display_name
    nome
  end
end
