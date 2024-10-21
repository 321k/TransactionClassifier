class RenameMerchantNameToDescriptionInTransactions < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :merchant_name, :description
  end
end
