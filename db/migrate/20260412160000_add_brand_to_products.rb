class AddBrandToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :brand, null: true, foreign_key: true
  end
end
