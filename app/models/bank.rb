class Bank < ApplicationRecord
  belongs_to :household
  has_many :bank_accounts, dependent: :destroy

  def self.ransackable_associations(auth_object = nil)
    ["bank_accounts", "household"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "household_id", "id", "link", "name", "requisition_id", "updated_at", "gocardless_bank_identifier"]
  end
end
