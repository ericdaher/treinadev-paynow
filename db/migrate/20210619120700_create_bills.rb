class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :amount
      t.references :payment_method, null: false, foreign_key: true
      t.date :due_date
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
