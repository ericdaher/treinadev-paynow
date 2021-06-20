class AddIdTokenToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :id_token, :string
    add_index :products, :id_token, unique: true
  end
end
