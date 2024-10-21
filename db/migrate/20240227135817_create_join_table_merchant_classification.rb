class CreateJoinTableMerchantClassification < ActiveRecord::Migration[7.0]
  def change
    create_join_table :merchants, :classifications do |t|
      t.index :merchant_id
      t.index :classification_id
    end
  end
end
