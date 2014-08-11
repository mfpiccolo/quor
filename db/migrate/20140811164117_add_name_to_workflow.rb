class AddNameToWorkflow < ActiveRecord::Migration
  def change
    add_column :workflows, :name, :string
  end
end
