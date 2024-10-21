require 'securerandom'
require 'dotenv/load'

class GocardlessClient
  include HTTParty
  base_uri 'https://bankaccountdata.gocardless.com/api/v2'

  def initialize
    @access_token = get_access_token
  end

  def get_access_token
    response = self.class.post("/token/new/",
      body: {
        secret_id: ENV['GC_SECRET_ID'],
        secret_key: ENV['GC_SECRET_KEY']
      }.to_json,
      headers: {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
    )

    if response.code == 200
      @access_expires = Time.now + response.parsed_response["access_expires"]
      @refresh_token = response.parsed_response["refresh"]
      @refresh_expires = Time.now + response.parsed_response["refresh_expires"]
      @access_token = response.parsed_response["access"]
    else
      puts "Error: #{response.code} - #{response.parsed_response}"
    end
  end

  def valid_token?
    Time.now < @access_expires
  end

  def refresh_token
    response = self.class.post("/token/refresh",
      body: {
        refresh_token: @refresh_token
      }.to_json,
      headers: {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
    )

    if response.code == 200
      @access_token = response.parsed_response["access"]
      @access_expires = Time.now + response.parsed_response["access_expires"]
    else
      # Handle error, possibly by re-authenticating entirely
      get_access_token
    end
  end

  def request_with_token(method, path, options = {})
    refresh_token unless valid_token?

    options[:headers] ||= {}
    options[:headers]["Authorization"] = "Bearer #{@access_token}"

    response = self.class.send(method, path, options)

    if response.success?
      response
    else
      # Handle error: log it, raise an exception, etc.
      puts "Error: #{response.code} - #{response.parsed_response}"
    end
  end

  def select_bank(country_code)
    response = request_with_token(:get, "/institutions/", headers: { country: country_code })

    if response
      response.parsed_response
    else
      # Handle error: log it, raise an exception, etc.
      nil
    end
  end

  def create_requisition(institution_id, redirect_url)

    body = {
      redirect: redirect_url,
      institution_id: institution_id,
      reference: SecureRandom.uuid,
    }.to_json
    response = request_with_token(:post, "/requisitions/", body: body, headers: { "Content-Type" => "application/json", "Accept" => "application/json" })

    if response
      response.parsed_response
    else
      # Handle error: log it, raise an exception, etc.
      nil
    end
  end

  def list_bank_accounts(requisition_id)
    response = request_with_token(:get, "/requisitions/#{requisition_id}/", headers: { "Content-Type" => "application/json", "Accept" => "application/json" })

    if response.success?
      response.parsed_response
    else
      # Handle error: log it, raise an exception, etc.
      log_error(response) # Make sure to define this method to handle logging
      nil
    end
  end

  def import_bank_accounts_from_api(requisition_id, bank)
    bank_accounts_data = list_bank_accounts(requisition_id)

    if bank_accounts_data && bank_accounts_data["status"] != "LN"
      Rails.logger.error "Bank account not linked yet. Status: #{bank_accounts_data["status"]}"
      false
    elsif bank_accounts_data && bank_accounts_data["accounts"]
      bank_accounts_data["accounts"].each do |account_number|
        BankAccount.find_or_create_by!(account_number: account_number, bank: bank)
      end
      true
    else
      false
    end
  rescue => e
    Rails.logger.error "Failed to import bank accounts: #{e.message}"
    false
  end

  def list_transactions(bank_account_number)
    response = request_with_token(:get, "/accounts/#{bank_account_number}/transactions/", headers: { "Content-Type" => "application/json", "Accept" => "application/json" })

    if response && response.code.between?(200, 299)
      response.parsed_response
    else
      # Handle error: log it, raise an exception, etc.
      log_error(response) # Ensure you define this method for error logging
      nil
    end
  end

  def import_transactions_from_api(bank_account_number, bank)
    transactions_data = list_transactions(bank_account_number)
    bank_account = BankAccount.find_or_create_by!(account_number: bank_account_number, bank: bank)

    if transactions_data && transactions_data["transactions"] && transactions_data["transactions"]["booked"]
      transactions_data["transactions"]["booked"].each do |transaction_data|

        description = transaction_data["remittanceInformationUnstructured"]

        # Create a new transaction in your database for each transaction in the API response
        Transaction.create!(
          booking_date: transaction_data["bookingDate"],
          value_date: transaction_data["valueDate"],
          amount: transaction_data["transactionAmount"]["amount"],
          currency: transaction_data["transactionAmount"]["currency"],
          description: transaction_data["remittanceInformationUnstructured"],
          internal_transaction_id: transaction_data["internalTransactionId"],
          bank_account: bank_account
        )
      end
      true # Return true if import is successful
    else
      false # Return false if there was an error or no data to import
    end
  rescue => e
    # Log the error
    Rails.logger.error "Failed to import transactions: #{e.message}"
    false
  end

end
