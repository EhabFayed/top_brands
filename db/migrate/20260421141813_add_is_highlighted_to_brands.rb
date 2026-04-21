class AddIsHighlightedToBrands < ActiveRecord::Migration[8.0]
  def change
    add_column :brands, :is_highlighted, :boolean, default: false
  end
end
