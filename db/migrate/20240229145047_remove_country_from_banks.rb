class RemoveCountryFromBanks < ActiveRecord::Migration[7.0]
  def change
    remove_column :banks, :country, :string
  end
end
