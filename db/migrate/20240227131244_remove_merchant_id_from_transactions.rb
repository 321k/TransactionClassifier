class RemoveMerchantIdFromTransactions < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :merchant_id, :integer
  end
end
