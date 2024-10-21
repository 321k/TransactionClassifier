ActiveAdmin.register Classification do
  permit_params :category, :sub_category, :confidence_score

  filter :category
  filter :sub_category
  filter :confidence_score
  filter :related_transaction_description, as: :string

  index do
    selectable_column
    id_column

    column :category
    column :sub_category
    column :confidence_score
    column :related_transaction
    column "Description" do |classification|
      classification.related_transaction&.description
    end
    column "Amount" do |classification|
      classification.related_transaction&.amount
    end
    column "Currency" do |classification|
      classification.related_transaction&.currency
    end
    actions defaults: true do |classification|
      item "Boost", increase_confidence_score_admin_classification_path(classification), class: "member_link"
      item "Reduce", decrease_confidence_score_admin_classification_path(classification), class: "member_link"
      # Add more custom actions here
    end
  end

  member_action :increase_confidence_score, method: :get do
    classification = find_resource
    classification.increase_confidence_score
    redirect_back(fallback_location: admin_classifications_path, notice: "Confidence score increased to #{classification.confidence_score}")
  end

  member_action :decrease_confidence_score, method: :get do
    classification = find_resource
    classification.decrease_confidence_score
    redirect_back(fallback_location: admin_classifications_path, notice: "Confidence score increased to #{classification.confidence_score}")
  end

  action_item :increase_confidence_score, only: :show do
    link_to 'Increase confidence', increase_confidence_score_admin_classification_path(resource), method: :get
  end

  action_item :decrease_confidence_score, only: :show do
    link_to 'Decrease confidence', decrease_confidence_score_admin_classification_path(resource), method: :get
  end
end
