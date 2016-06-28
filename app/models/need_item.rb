class NeedItem < ActiveRecord::Base
  belongs_to :need
  belongs_to :recipient
  has_many :donation_items

  def self.find_family(id)
    find(id).family
  end

  def name
    supply.name
  end

  def description
    supply.description
  end

  def value
    supply.value
  end

  def quantity_remaining
    quantity - donation_items.sum(:quantity)
  end

  def subtotal(quantity)
    supply.value * quantity
  end
end
