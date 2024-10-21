class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :merchant_name
      t.references :user, null: false, foreign_key: true
      t.date :booking_date
      t.date :value_date
      t.references :classification, null: false, foreign_key: true

      t.timestamps
    end
  end
end
