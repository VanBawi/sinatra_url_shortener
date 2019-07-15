class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string  :url
      t.string  :user_name
      t.integer :user_id
      t.string  :original_url
      t.string  :short_url
      t.timestamps
    end
  end
end
