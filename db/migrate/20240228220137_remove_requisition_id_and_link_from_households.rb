class RemoveRequisitionIdAndLinkFromHouseholds < ActiveRecord::Migration[6.0]
  def change
    remove_column :households, :requisition_id, :string
    remove_column :households, :link, :string
  end
end
