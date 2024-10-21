ActiveAdmin.register Transaction do

  index do
    selectable_column
    id_column
    column :booking_date
    column :amount
    column :currency
    column :description
    column :bank_account
    column 'Categories' do |transaction|
      # Generate links for each category
      transaction.classifications.map do |classification|
        link_to classification.category, admin_classification_path(classification)
      end.join(", ").html_safe
    end
    actions defaults: true do |transaction|
      item "Classify", classify_transaction_admin_transaction_path(transaction), class: "member_link"
      # Add more custom actions here
    end
  end

  permit_params :amount, :description, :booking_date, :value_date, :user_id, :merchant_id

  filter :amount
  filter :description
  filter :booking_date
  filter :value_date
  filter :classifications_category, as: :string
  # This block defines the layout for the show page
  show do |transaction|
    attributes_table do
      row :description
      row :created_at
      row :updated_at
      row 'Categories' do |transaction|
        transaction.classifications.map(&:category).join(", ")
      end
      row 'Sub categories' do |transaction|
        transaction.classifications.map(&:sub_category).join(", ")
      end
    end

    active_admin_comments
  end

  # Define a member action for classification
  member_action :classify_transaction, method: :get do
    # Assuming `MerchantClassifier` is a service class that performs the classification
    # And `find_resource` is a method provided by Active Admin to find the current resource based on the ID in the URL
    transaction = find_resource
    classification_result = OpenaiClient.new.add_classification_to_transaction(transaction)

    # Redirect back to the merchant view or wherever appropriate
    redirect_back(fallback_location: admin_transactions_path, notice: "Transaction classified as #{classification_result}")
  end

  # Add an action item (button) to classify the merchant
  action_item :classify_transaction, only: :show do
    link_to 'Classify transaction', classify_transaction_admin_transaction_path(resource), method: :get
  end

  batch_action :classify do |ids|
    batch_action_collection.find(ids).each do |transaction|
      OpenaiClient.new.add_classification_to_transaction(transaction)
    end
    redirect_back(fallback_location: admin_transactions_path, notice: "The transfers have been classified.")
  end

end
