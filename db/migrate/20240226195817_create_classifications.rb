class CreateClassifications < ActiveRecord::Migration[7.0]
  def change
    create_table :classifications do |t|
      t.string :category
      t.string :sub_category
      t.references :merchant, null: false, foreign_key: true
      t.integer :confidence_score

      t.timestamps
    end
  end
end
