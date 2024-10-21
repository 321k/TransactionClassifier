class RemoveBankNameFromBankAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :bank_accounts, :bank, :string
  end
end
