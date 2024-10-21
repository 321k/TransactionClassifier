# app/models/transaction.rb
class Transaction < ApplicationRecord
  belongs_to :bank_account
  has_many :classifications, inverse_of: 'related_transaction'

  after_create :initial_classification

  def initial_classification
    if self.classifications.empty?
      classification_result = find_existing_classification
      if classification_result.length > 0
        classification = Classification.new(category: classification_result[0]['category'], confidence_score: classification_result[0]['mean'].to_i, transaction_id: self.id)
        if classification.save
          "Classified with existing data."
        else
          puts "Failed to save classification: #{classification.errors.full_messages.join(", ")}"
        end
      else
        classification_result = OpenaiClient.new.add_classification_to_transaction(self)
        'Classified with OpenAI.'
      end
    else
      'Already classified.'
    end
  end

  def find_existing_classification
    sql = <<-SQL
      WITH mean_confidence as (
      select
      transactions.description
      , classifications.category
      , avg(classifications.confidence_score) as mean
      , min(classifications.confidence_score) as min
      , max(classifications.confidence_Score) as max
      from classifications
      join transactions on transactions.id = classifications.transaction_id
      where transactions.description = '#{description}'
      group by 1, 2
      ),

      confidence_ranking AS (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY description ORDER BY mean DESC) AS rn
            FROM mean_confidence
          )

      select * from  confidence_ranking
      where rn = 1
    SQL
    sanitized_sql = ActiveRecord::Base.sanitize_sql_array([sql])
    results = ActiveRecord::Base.connection.execute(sanitized_sql)
    results
  end

  # Define which attributes are searchable.
  def self.ransackable_attributes(auth_object = nil)
    # List the attributes you want to be searchable. For example:
    ["amount", "booking_date", "created_at", "id", "description", "updated_at", "user_id", "value_date"]
    # Ensure to exclude any sensitive or irrelevant attributes for searching.
  end

  def self.ransackable_associations(auth_object = nil)
    ["classifications", "bank_accounts"]
  end

end
