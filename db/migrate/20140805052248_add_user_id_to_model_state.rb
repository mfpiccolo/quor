class AddUserIdToModelState < ActiveRecord::Migration
  def change
    add_column :model_states, :user_id, :integer
  end
end
