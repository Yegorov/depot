class CombineItemsInCart < ActiveRecord::Migration[5.1]
  def up
    # Заменить множество одного типа товара, на один товар с его количеством
    Cart.all.each do |cart|
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          cart.line_items.where(product_id: product_id).delete_all

          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end
  def down
    # Для товара с кол-вом больше 1, нужно создать много одних и тех же позиций
    LineItem.where("quantity > 1").each do |line_item|
      line_item.quantity.times do
        LineItem.create(
          cart_id: line_item.cart_id,
          product_id: line_item.product_id,
          quantity: 1
        )
      end
      line_item.destroy
    end
  end
end
