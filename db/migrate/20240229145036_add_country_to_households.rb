class AddCountryToHouseholds < ActiveRecord::Migration[7.0]
  def change
    add_column :households, :country, :string
  end
end
