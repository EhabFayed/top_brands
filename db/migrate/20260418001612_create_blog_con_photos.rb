class CreateBlogConPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :blog_con_photos do |t|
      t.references :blog_content, null: false, foreign_key: true
      t.string :alt_ar
      t.string :alt_en
      t.timestamps
    end
  end
end
