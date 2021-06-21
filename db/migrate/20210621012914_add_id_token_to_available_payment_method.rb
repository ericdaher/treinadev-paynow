class AddIdTokenToAvailablePaymentMethod < ActiveRecord::Migration[6.1]
  def change
    add_column :available_payment_methods, :id_token, :string
    add_index :available_payment_methods, :id_token, unique: true
  end
end
