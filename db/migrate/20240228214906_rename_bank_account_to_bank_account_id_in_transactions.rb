class RenameBankAccountToBankAccountIdInTransactions < ActiveRecord::Migration[7.0]
  def change
    rename_column :transactions, :bank_account, :bank_account_id
  end
end
