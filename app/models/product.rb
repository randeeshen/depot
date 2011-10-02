class Product < ActiveRecord::Base
  
  # Default all queries that start with the Product
  # to be ordered by title
  default_scope :order => 'title'
  scope :all_active, :conditions => {:active => true}
  scope :all_inactive, :conditions => {:active => false}

  has_many :line_items
  has_many :orders, :through => :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  validates :image_url, :format => {
    :with => %r{\.(gif|jpg|png)$}i,
    :message => 'must be a URL for GIF, JPG or PNG image.'
  }

  private 
    #  ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else 
        errors.add(:base, 'Line Items present')
        return false
      end
    end
end
