class RemoveClassificationIdFromTransactions < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :classification_id, :integer
  end
end
