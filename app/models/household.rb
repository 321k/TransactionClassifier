class Household < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :banks, dependent: :destroy

  def spend_by_month
    sql = <<-SQL
    WITH max_confidence AS (
      SELECT
      transactions.id as transaction_id
      ,transactions.description
      ,classifications.confidence_score
      ,classifications.category
      , ROW_NUMBER() OVER (PARTITION BY description ORDER BY confidence_score DESC) AS rn
      FROM classifications
      join transactions on transactions.id = classifications.transaction_id
    ),
    deduped_transactions AS (
      SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY internal_transaction_id ORDER BY updated_at DESC) AS rn
      FROM transactions
    )
    SELECT
    strftime('%Y-%m', deduped_transactions.booking_date) AS month_year
    , round(SUM(deduped_transactions.amount), 2) AS total_amount
    FROM deduped_transactions
    JOIN bank_accounts ON bank_accounts.id = deduped_transactions.bank_account_id
    JOIN banks ON banks.id = bank_accounts.bank_id
    LEFT JOIN max_confidence ON max_confidence.transaction_id = deduped_transactions.id AND max_confidence.rn = 1
    WHERE banks.household_id = #{id}
    and deduped_transactions.rn = 1
    GROUP BY 1
    SQL

    results = ActiveRecord::Base.connection.execute(sql)
    results
  end

  def spend_by_month_and_category
    sql = <<-SQL
    WITH max_confidence AS (
      SELECT
      transactions.id as transaction_id
      ,transactions.description
      ,classifications.confidence_score
      ,classifications.category
      ,classifications.sub_category
      ,ROW_NUMBER() OVER (PARTITION BY transactions.id ORDER BY confidence_score DESC) AS rn
      FROM classifications
      join transactions on transactions.id = classifications.transaction_id
    ),
    deduped_transactions AS (
      SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY internal_transaction_id ORDER BY updated_at DESC) AS rn
      FROM transactions

    )
    SELECT
    strftime('%Y-%m', deduped_transactions.booking_date) AS month_year
    , max_confidence.category AS category
    , round(SUM(deduped_transactions.amount), 2) AS total_amount
    FROM deduped_transactions
    JOIN bank_accounts ON bank_accounts.id = deduped_transactions.bank_account_id
    JOIN banks ON banks.id = bank_accounts.bank_id
    LEFT JOIN max_confidence ON max_confidence.transaction_id = deduped_transactions.id AND max_confidence.rn = 1
    WHERE banks.household_id = #{id}
    and deduped_transactions.rn = 1
    GROUP BY 1, 2
    SQL

    results = ActiveRecord::Base.connection.execute(sql)
    results
  end

  def spend_by_month_and_category_and_bank
    sql = <<-SQL
    WITH max_confidence AS (
      SELECT
      transactions.id as transaction_id
      ,transactions.description
      ,classifications.confidence_score
      ,classifications.category
      ,classifications.sub_category
      ,ROW_NUMBER() OVER (PARTITION BY transactions.id ORDER BY confidence_score DESC) AS rn
      FROM classifications
      join transactions on transactions.id = classifications.transaction_id
    ),
    deduped_transactions AS (
      SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY internal_transaction_id ORDER BY updated_at DESC) AS rn
      FROM transactions

    )
    SELECT
    strftime('%Y-%m', deduped_transactions.booking_date) AS month_year
    , banks.name AS bank_name
    , max_confidence.category
    , max_confidence.sub_category
    , round(SUM(deduped_transactions.amount), 2) AS total_amount
    FROM deduped_transactions
    JOIN bank_accounts ON bank_accounts.id = deduped_transactions.bank_account_id
    JOIN banks ON banks.id = bank_accounts.bank_id
    LEFT JOIN max_confidence ON max_confidence.transaction_id = deduped_transactions.id AND max_confidence.rn = 1
    WHERE banks.household_id = #{id}
    and deduped_transactions.rn = 1
    GROUP BY 1, 2, 3, 4
    SQL

    results = ActiveRecord::Base.connection.execute(sql)
    results
  end


  def self.ransackable_attributes(auth_object = nil)
    # List the attributes you want to be searchable. For example:
    ["name", "link", "country", "requisition_id", "created_at", "updated_at"]
    # Ensure to exclude any sensitive or irrelevant attributes for searching.
  end

  def self.ransackable_associations(auth_object = nil)
    ["users", "banks"]
  end
end
