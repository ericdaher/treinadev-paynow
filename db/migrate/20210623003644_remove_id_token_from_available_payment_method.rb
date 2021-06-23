class RemoveIdTokenFromAvailablePaymentMethod < ActiveRecord::Migration[6.1]
  def change
    remove_column :available_payment_methods, :id_token, :token
  end
end
