class CreatePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.integer :method_type, default: 0
      t.decimal :payment_tax
      t.decimal :max_tax
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
