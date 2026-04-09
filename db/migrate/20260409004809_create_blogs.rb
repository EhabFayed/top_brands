class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.string :title_ar
      t.string :title_en
      t.text   :description_ar
      t.text   :description_en
      t.string :meta_title_ar
      t.string :meta_title_en
      t.string :slug
      t.string :slug_ar
      t.text :meta_description_ar
      t.text :meta_description_en
      t.boolean :is_published, default: false
      t.integer :category
      t.timestamps
    end
    add_index :blogs, :slug, unique: true
    add_index :blogs, :slug_ar, unique: true
  end
end
