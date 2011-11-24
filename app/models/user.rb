class User < ActiveRecord::Base

  usar_como_cpf :cpf
  has_many :orders, :dependent => :destroy
  belongs_to :site
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :cpf, :nome, :endereco, :sexo, :data_nasc, :telefone, :celular, :email, :password, :password_confirmation, :site_id

  attr_accessor :password
  before_save :prepare_password

  validates_presence_of :cpf, :email, :nome, :endereco, :data_nasc, :sexo, :telefone
  validates_uniqueness_of :cpf, :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6, :allow_blank => true

  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_email(login)
    return user if user && user.matching_password?(pass)
  end

  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = encrypt_password(password)
    end
  end

  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end
end
