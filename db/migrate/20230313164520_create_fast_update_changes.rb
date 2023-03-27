class CreateFastUpdateChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :fast_update_changes do |t|
      t.string :old_uri
      t.string :old_label
      t.string :action
      t.string :new_uris, array: true, default: [], using: "(string_to_array(new_uris, ','))"
      t.string :new_labels, array: true, default: [], using: "(string_to_array(new_labels, ','))"
      t.string :collection_id, :string
      t.boolean :complete
      t.integer :count

      t.timestamps
    end
  end
end
