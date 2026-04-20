class AddDescriptionToBrands < ActiveRecord::Migration[8.0]
  def change
    add_column :brands, :description_ar, :text
    add_column :brands, :description_en, :text
    add_column :brands, :meta_title_ar, :string
    add_column :brands, :meta_title_en, :string
    add_column :brands, :meta_description_ar, :text
    add_column :brands, :meta_description_en, :text
  end
end
