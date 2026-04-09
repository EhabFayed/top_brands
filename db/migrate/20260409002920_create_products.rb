class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :title_ar, null: false
      t.string :title_en, null: false
      t.text   :description_ar
      t.text   :description_en
      t.string :alt_text_ar
      t.string :alt_text_en
      t.integer :display_order, default: 0
      t.string :size
      t.timestamps
    end
  end
end
