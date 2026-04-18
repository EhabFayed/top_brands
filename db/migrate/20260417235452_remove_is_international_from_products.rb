class RemoveIsInternationalFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :is_international, :boolean
    add_column :brands, :is_international, :boolean, default: false
  end
end