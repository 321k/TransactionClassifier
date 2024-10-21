class AddFieldsToClassifications < ActiveRecord::Migration[7.0]
  def change
    add_column :classifications, :category, :string
    add_column :classifications, :sub_category, :string
    add_column :classifications, :confidence_score, :integer
  end
end
