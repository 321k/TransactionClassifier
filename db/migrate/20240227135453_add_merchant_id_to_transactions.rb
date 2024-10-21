class AddMerchantIdToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :merchant_id, :integer
  end
end
