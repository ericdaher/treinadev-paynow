class AddIdTokenToPaymentMethod < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_methods, :id_token, :string
    add_index :payment_methods, :id_token, unique: true
  end
end
