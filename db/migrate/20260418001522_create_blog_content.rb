class CreateBlogContent < ActiveRecord::Migration[8.0]
  def change
    create_table :blog_contents do |t|
      t.references :blog, null: false, foreign_key: true
      t.text :content_ar
      t.text :content_en
      t.timestamps
    end
  end
end
