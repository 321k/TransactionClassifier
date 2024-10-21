class RemoveMerchantIdFromClassificationsAgain < ActiveRecord::Migration[6.0]
  def change
    remove_column :classifications, :merchant_id, :integer
  end
end
