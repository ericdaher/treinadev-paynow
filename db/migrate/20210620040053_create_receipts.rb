class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.date :due_date
      t.date :payment_date
      t.decimal :amount
      t.text :description
      t.references :bill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
