class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.string     :key,          null: false
      t.text       :value
      t.string     :content_type
      t.integer    :position,     null: false, default: 0
      t.references :parentable, polymorphic: true, index: true


      t.timestamps
    end

    add_index :contents, [:parentable_type, :parentable_id]
    add_index :contents, :position
  end
end
