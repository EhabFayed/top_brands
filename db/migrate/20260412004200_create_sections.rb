class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.string  :page,         null: false
      t.string  :section_type, null: false
      t.integer :position,     null: false, default: 0
      t.jsonb   :settings,     null: false, default: {}

      t.timestamps
    end

    add_index :sections, :page
    add_index :sections, :section_type
    add_index :sections, [:page, :section_type]
    add_index :sections, :settings, using: :gin
  end
end
