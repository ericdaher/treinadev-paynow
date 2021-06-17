class CreateAvailablePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :available_payment_methods do |t|
      t.references :payment_method, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
