class AddCustomerRefToBills < ActiveRecord::Migration[6.1]
  def change
    add_reference :bills, :customer, null: false, foreign_key: true
  end
end
