class RemoveUserIdFromBankAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :bank_accounts, :user_id, :integer
  end
end
