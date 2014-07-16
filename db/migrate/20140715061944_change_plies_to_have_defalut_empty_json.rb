class ChangePliesToHaveDefalutEmptyJson < ActiveRecord::Migration
  def change
    execute "ALTER TABLE plies ALTER COLUMN data SET DEFAULT '{}'::JSON"
  end
end
