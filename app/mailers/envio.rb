class Envio < ActionMailer::Base
  default :from => "from@example.com"
  
  def enviado(pedido)
    mail :to => pedido.customer.email, :subject => "Pedido Enviado"    
  end
end
