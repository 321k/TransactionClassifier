class BankAccount < ApplicationRecord
  belongs_to :bank
  has_many :transactions, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    # List the attributes you want to be searchable. For example:
    ["account_number", "created_at", "id", "updated_at", "bank_name", "nickname", "household_id"]
    # Ensure to exclude any sensitive or irrelevant attributes for searching.
  end

  def self.ransackable_associations(auth_object = nil)
    ["household", "transactions"]
  end
end
