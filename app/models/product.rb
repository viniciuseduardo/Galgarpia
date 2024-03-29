class Product < ActiveRecord::Base
  belongs_to :site

  # Named Scopes
  scope :available, lambda{ where("available_on < ?", Date.today) }
  scope :drafts, lambda{ where("available_on > ?", Date.today) }

  # Validations
  validates_presence_of :title
  validates_presence_of :price
  validates_presence_of :image_file_name

  attr_accessible :title, :price, :image_file_name, :site, :site_id
end
