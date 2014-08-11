class CreateWorkflow < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.integer :user_id
      t.string  :model_otype
      t.text    :trigger_text
      t.string  :trigger_recipient
      t.string  :trigger_function
      t.string  :trigger_arg
      t.text    :condition_text
      t.string  :condition_recipient
      t.string  :condition_function
      t.string  :condition_arg
      t.text    :action_text
      t.string  :action_function
      t.string  :action_recipient
      t.string  :action_arg

      t.timestamps
    end
  end
end
