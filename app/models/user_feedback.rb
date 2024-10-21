# app/models/user_feedback.rb
class UserFeedback < ApplicationRecord
  belongs_to :user
  belongs_to :classification

  def self.ransackable_attributes(auth_object = nil)
    ["classification_id", "created_at", "feedback_type", "id", "transaction_id", "updated_at", "user_id"]
  end
end
