class AddValueEnToContents < ActiveRecord::Migration[8.0]
  def change
    add_column :blogs, :alt_ar, :string
    add_column :blogs, :alt_en, :string
    add_column :contents, :value_en, :text
    add_column :contents, :value_ar, :text
    remove_column :contents, :value, :text
  end
end
