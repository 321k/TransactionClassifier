ActiveAdmin.register BankAccount do

  permit_params :account_number, :bank_name, :nickname, :household_id

  filter :account_number
  filter :bank_name
  filter :nickname

  member_action :fetch_transactions, method: :get do
    bank_account = find_resource
    response = GocardlessClient.new.import_transactions_from_api(bank_account.account_number, bank_account.bank)
    redirect_to admin_bank_account_path(bank_account), notice: "Transfers fetched."
  end

  # Add an action item (button) to fetch transactions
  action_item :fetch_transactions, only: :show do
    link_to 'Fetch transactions', fetch_transactions_admin_bank_account_path(resource), method: :get
  end
end
