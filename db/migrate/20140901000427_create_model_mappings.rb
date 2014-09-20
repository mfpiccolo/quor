class CreateModelMappings < ActiveRecord::Migration
  def change
    create_table :model_mappings do |t|
      t.integer :user_id
      t.string  :otype
      t.json    :type_mapping

      t.timestamps
    end
  end
end
