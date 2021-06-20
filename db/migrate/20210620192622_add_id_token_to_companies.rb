class AddIdTokenToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :id_token, :string
    add_index :companies, :id_token, unique: true
  end
end
