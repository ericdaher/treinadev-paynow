class AddActiveToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :active, :boolean, default: true
  end
end
