ActiveAdmin.register Bank do
  permit_params :name, :link, :requisition_id, :household_id, :gocardless_bank_identifier

  form do |f|
    f.semantic_errors
    f.inputs 'Bank' do
      f.input :household_id, as: :select, collection: Household.all.map { |household| [household.name, household.id] }, include_blank: 'Select a Household'
      f.input :name
      f.input :gocardless_bank_identifier, as: :string
    end
    f.actions
  end


  member_action :generate_link, method: :get do
    # `find_resource` is a method provided by Active Admin to find the current resource based on the ID in the URL
    bank = find_resource
    requisition = GocardlessClient.new.create_requisition(bank.gocardless_bank_identifier, "https://localhost:3000/banks/#{bank.id}/link")
    bank.link = requisition['link']
    bank.requisition_id = requisition['id']

    # Save the changes
    if bank.save
      redirect_to admin_bank_path(bank), notice: "Requisition created successfully."
    else
      redirect_to admin_bank_path(bank), alert: "Failed to update bank."
    end
  end

  member_action :fetch_bank_accounts, method: :get do
    # `find_resource` is a method provided by Active Admin to find the current resource based on the ID in the URL
    bank = find_resource
    response = GocardlessClient.new.import_bank_accounts_from_api(bank['requisition_id'], bank)
    if response
      redirect_to admin_bank_path(bank), notice: "Bank accounts fetched. #{response}"
    else
      redirect_to admin_bank_path(bank), notice: "Failed to fetch bank accounts. #{response}"
    end
  end


  # Add an action item (button) to fetch transactions
  action_item :generate_link, only: :show do
    link_to 'Generate link', generate_link_admin_bank_path(resource), method: :get
  end

  action_item :fetch_bank_accounts, only: :show do
    link_to 'Fetch bank accounts', fetch_bank_accounts_admin_bank_path(resource), method: :get
  end
end
