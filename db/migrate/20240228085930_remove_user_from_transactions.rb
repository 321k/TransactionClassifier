class RemoveUserFromTransactions < ActiveRecord::Migration[6.0]
  def change
    remove_reference :transactions, :user, index: true, foreign_key: true
  end
end
