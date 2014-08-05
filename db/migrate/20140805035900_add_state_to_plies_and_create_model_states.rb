class AddStateToPliesAndCreateModelStates < ActiveRecord::Migration
  def change
    add_column :plies, :model_state_id, :integer

    create_table :model_states do |t|
      t.string :name
      t.string :otype
      t.string :transition_to
      t.string :transition_from

      t.timestamps
    end
  end
end
