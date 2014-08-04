class AddLastVersionChangesToModels < ActiveRecord::Migration
  def change
    add_column :plies, :last_version_changes, :json
    execute "ALTER TABLE plies ALTER COLUMN last_version_changes SET DEFAULT '{}'"
  end
end
