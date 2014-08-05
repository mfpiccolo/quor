class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.string   :whodunnit_email
      t.text     :object
      t.string   :otype
      t.json     :diff
      t.datetime :created_at
    end
    add_index :versions, [:item_type, :item_id]
  end
end
