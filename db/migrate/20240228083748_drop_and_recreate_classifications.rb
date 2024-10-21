class DropAndRecreateClassifications < ActiveRecord::Migration[7.0]
  def up
    drop_table :classifications, if_exists: true
    create_table :classifications do |t|
      t.references :merchant, null: false, foreign_key: true
      # Add other necessary columns here
    end
  end

  def down
    # Code to revert the migration, if needed. This might include recreating the old table structure.
    # However, if dropping data was your intention, you might not need a detailed down method.
  end
end
