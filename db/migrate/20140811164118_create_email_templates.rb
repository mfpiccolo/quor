class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.integer :user_id
      t.string  :logo_file
      t.string  :banner_file
      t.text    :subject
      t.string  :header1_large
      t.text    :header1_small
      t.text    :banner_description
      t.string  :header2_large
      t.string  :header2_small
      t.text    :body
      t.string  :call_to_action
      t.string  :facebook_url
      t.string  :twitter_url
      t.string  :google_url

      t.timestamps
    end
  end
end
