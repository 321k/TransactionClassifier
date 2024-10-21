class AddTransactionToClassifications < ActiveRecord::Migration[6.0]
  def change
    add_column :classifications, :transaction_id, :integer
    add_foreign_key :classifications, :transactions
    add_index :classifications, :transaction_id
  end
end
