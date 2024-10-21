class CreateBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :banks do |t|
      t.string :name
      t.string :requisition_id
      t.string :link
      t.string :country
      t.references :household, null: false, foreign_key: true

      t.timestamps
    end
  end
end
