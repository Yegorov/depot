class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  validates :title, length: 1..40

  has_many :line_items
  # Нельзя удалить продукт, если он находится у кого-то в корзине
  before_destroy :ensure_not_referenced_by_any_line_item

  has_many :orders, through: :line_items


  private
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end
end
