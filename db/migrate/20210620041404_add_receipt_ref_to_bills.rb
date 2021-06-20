class AddReceiptRefToBills < ActiveRecord::Migration[6.1]
  def change
    add_reference :bills, :receipt, foreign_key: true
  end
end
