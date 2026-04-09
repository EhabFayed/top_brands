class CreateBrands < ActiveRecord::Migration[8.0]
  def change
    create_table :brands do |t|
      t.string :title_ar, null: false
      t.string :title_en, null: false
      t.string :alt_text_ar
      t.string :alt_text_en
      t.timestamps
    end
  end
end
