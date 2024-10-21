class AddRequisitionIdAndLinkToHouseholds < ActiveRecord::Migration[7.0]
  def change
    add_column :households, :requisition_id, :string
    add_column :households, :link, :string
  end
end
