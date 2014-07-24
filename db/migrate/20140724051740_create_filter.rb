class CreateFilter < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.references :user
      t.string     :model_type
      t.text       :query
      t.string     :name
    end
  end
end
