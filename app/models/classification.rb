# app/models/classification.rb
class Classification < ApplicationRecord
  belongs_to :related_transaction, class_name: 'Transaction', foreign_key: 'transaction_id', inverse_of: 'classifications'

  def self.ransackable_attributes(auth_object = nil)
    ["category", "confidence_score", "created_at", "id", "sub_category", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["related_transaction"]
  end

  def increase_confidence_score
    if self.confidence_score + 10 < 100
      self.confidence_score += 10
      save
    else
      self.confidence_score = 100
      save
    end
  end

  def decrease_confidence_score
    if self.confidence_score - 10 > 0
      self.confidence_score -= 10
      save
    else
      self.confidence_score = 0
      save
    end
  end

end
