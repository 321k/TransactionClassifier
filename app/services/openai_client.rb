require 'dotenv/load'

class OpenaiClient
  include HTTParty
  base_uri 'https://api.openai.com/v1'

  def initialize
    @api_key = ENV['OAI_API_KEY']
  end

  def completion(transaction)
    existing_classification = transaction.find_existing_classification

    classification_prompt = "Given the transaction description and amount, classify the transaction into categories such as Food, Entertainment, Utilities, Travel, or Other. If it has a minus sign, it's an expense. Otherwise, it's  some kind of income. Description: '#{transaction.description}'. Amount: '#{transaction.amount}' '#{transaction.currency}'."
    if existing_classification.length > 0
      classification_prompt += " A transaction with the same description was previously categorised as #{existing_classification[0]['category']} and a sub category of #{existing_classification[0]['sub_category']} with a confidence score of #{existing_classification[0]['mean']}/100. Take this into consideration."
    else

    end
    response = self.class.post("/chat/completions",
      body: {
        model: "gpt-3.5-turbo",
        response_format: { "type": "json_object" },
        messages: [
          {
            role: "system",
            content: "You are a helpful bank transaction classifier designed to output JSON in the format {'category': category, 'sub_category': sub_category, 'confidence': confidence_score}. Generate a one-word best guess classification that is useful for budgeting of this bank statement transaction. Also provide a confidence score from 0 to 100 that reflects the likely accuracy of the classification. Generic categories such as Other should result in a low confidence score."
          },
          {
            role: "user",
            content: classification_prompt
          },
        ]
      }.to_json,
      headers: {
        "Authorization" => 'Bearer ' + @api_key,
        "Content-Type" => "application/json"
      }
    )

    res = response.parsed_response["choices"].first["message"]["content"]
    JSON.parse(res)
  end

  def add_classification_to_transaction(transaction)
    c = completion(transaction)
    classification = transaction.classifications.create(category: c["category"], sub_category: c["sub_category"], confidence_score: c["confidence"])
    if classification.save
      # If save returns true, the object was saved successfully.
      puts "Classification saved successfully."
      c
    else
      # If save returns false, print/log the errors.
      puts "Failed to save classification: #{classification.errors.full_messages.join(", ")}"
    end
  end
end
