class CreateBillingAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_attempts do |t|
      t.date :attempt_date
      t.integer :status
      t.references :bill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
