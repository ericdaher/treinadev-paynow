class AddCompanyRefToBills < ActiveRecord::Migration[6.1]
  def change
    add_reference :bills, :company, null: false, foreign_key: true
  end
end
