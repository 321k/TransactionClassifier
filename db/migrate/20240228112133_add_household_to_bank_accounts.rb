class AddHouseholdToBankAccounts < ActiveRecord::Migration[7.0]
  def change

    # Danger: This will permanently remove all existing bank_accounts records
    BankAccount.delete_all

    add_reference :bank_accounts, :household, null: false, foreign_key: true
  end
end
