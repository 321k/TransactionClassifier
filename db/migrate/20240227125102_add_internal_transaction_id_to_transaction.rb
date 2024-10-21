class AddInternalTransactionIdToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :internal_transaction_id, :string
  end
end
