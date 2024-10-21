class RemoveMerchantIdFromClassifications < ActiveRecord::Migration[7.0]
  def change
    remove_column :classifications, :merchant_id, :integer
  end
end
