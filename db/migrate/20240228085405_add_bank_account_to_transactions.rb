class AddBankAccountToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :bank_account, :string
  end
end
