class CreateLeadership < ActiveRecord::Migration[8.0]
  def change
    create_table :leaderships do |t|
      t.string :name_ar, null: false
      t.string :name_en, null: false
      t.string :position_ar
      t.string :position_en
      t.text   :description_ar
      t.text   :description_en
      t.string :alt_text_ar
      t.string :alt_text_en
      t.integer :display_order, default: 0
      t.timestamps
    end
  end
end
