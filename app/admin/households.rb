ActiveAdmin.register Household do
  permit_params :name, :link, :requesition_id, :country

  index do
    selectable_column
    id_column
    column :name
    column :country
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Household Details' do
      f.input :name
      f.input :country, as: :string
    end
    f.actions
  end


  # This block defines the layout for the show page
  show do |household|
    attributes_table do
      row :name
      row :country
      row :link
      row :requisition_id
      row :created_at
      row :updated_at
      row "Banks" do |household|
        # Collecting account numbers and joining them with a separator (e.g., ", ")
        household.banks.map(&:name).join(", ")
      end
    end

    # Data for the spend overview chart
    overview_data = household.spend_by_month.map do |record|
      {
        month_year: record['month_year'],
        total_amount: record['total_amount']
      }
    end

    # JavaScript-friendly data
    overview_labels = overview_data.map { |d| d[:month_year] }
    overview_values = overview_data.map { |d| d[:total_amount] }

    panel 'Monthly Spend Overview Graph' do
      canvas id: 'spend_overview_graph', style: 'height: 400px;'
    end

    # Data for the spend by catehory chart
    category_data = household.spend_by_month_and_category
    category_labels = category_data.map { |d| d["month_year"] }.uniq

    categories_data = category_data.each_with_object({}) do |record, obj|
      category = record["category"] || "Uncategorized" # Handle nil categories
      obj[category] ||= []
      obj[category] << record["total_amount"]
    end

    # Ensure each category array has the same number of elements as there are labels
    categories_data.each do |category, amounts|
      if amounts.length < category_labels.length
        # If any month is missing data for this category, add a 0 (or another placeholder)
        (category_labels.length - amounts.length).times { amounts << 0 }
      end
    end

    # JavaScript-friendly data
    overview_labels = overview_data.map { |d| d[:month_year] }
    overview_values = overview_data.map { |d| d[:total_amount] }


    panel 'Monthly Spend By Category' do
      canvas id: 'spend_by_category_graph', style: 'height: 400px;'
    end

    render 'admin/shared/chart', overview_labels: overview_labels, overview_values: overview_values, category_labels: category_labels, categories_data: categories_data



    panel "Monthly spend" do
      table_for household.spend_by_month_and_category_and_bank do
        column 'month_year'
        column 'bank_name'
        column 'category'
        column 'sub_category'
        column 'total_amount'
      end
    end

    active_admin_comments
  end
end
