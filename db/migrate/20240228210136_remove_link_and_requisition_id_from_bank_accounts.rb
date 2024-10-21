class RemoveLinkAndRequisitionIdFromBankAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :bank_accounts, :link, :string
    remove_column :bank_accounts, :requisition_id, :string
  end
end
