class MakeClassificationIdOptionalInTransactions < ActiveRecord::Migration[7.0]
  def change
    change_column_null :transactions, :classification_id, true
  end
end
