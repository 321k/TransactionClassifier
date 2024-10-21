class RemoveHouseholdFromBankAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_reference :bank_accounts, :household, null: false, foreign_key: true
  end
end
