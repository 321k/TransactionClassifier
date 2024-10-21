class AddGocardlessBankIdentifierToBanks < ActiveRecord::Migration[7.0]
  def change
    add_column :banks, :gocardless_bank_identifier, :string
  end
end
