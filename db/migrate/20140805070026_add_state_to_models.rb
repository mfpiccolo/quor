class AddStateToModels < ActiveRecord::Migration
  def change
    add_column :plies, :state, :string
  end
end
