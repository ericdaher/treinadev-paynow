class AddIdTokenToBills < ActiveRecord::Migration[6.1]
  def change
    add_column :bills, :id_token, :string
    add_index :bills, :id_token, unique: true
  end
end
