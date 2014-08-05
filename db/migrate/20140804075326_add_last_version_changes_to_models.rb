class AddLastVersionChangesToModels < ActiveRecord::Migration
  def up
    add_column :plies, :last_version_changes, :json
    execute "ALTER TABLE plies ALTER COLUMN last_version_changes SET DEFAULT '{}'"
  end

  def down
    remove_column :plies, :last_version_changes
  end
end
