class DropJoinTableForMerchantsClassifications < ActiveRecord::Migration[7.0]
  def change
    drop_table :classifications_merchants
  end
end
