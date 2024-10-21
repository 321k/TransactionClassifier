class ChangeHouseholdIdOptionalInUsers < ActiveRecord::Migration[6.0] # or your Rails version
  def change
    change_column_null :users, :household_id, true
  end
end
