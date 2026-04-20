class AddIsPublished < ActiveRecord::Migration[8.0]
  def change
    add_column :brands, :is_published, :boolean, default: false
    add_column :products, :is_published, :boolean, default: false
  end
end
