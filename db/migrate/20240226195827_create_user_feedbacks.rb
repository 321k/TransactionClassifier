class CreateUserFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_feedbacks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :transaction, null: false, foreign_key: true
      t.references :classification, null: false, foreign_key: true
      t.string :feedback_type

      t.timestamps
    end
  end
end
