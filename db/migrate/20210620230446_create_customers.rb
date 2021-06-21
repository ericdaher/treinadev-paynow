class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :cpf
      t.string :id_token

      t.timestamps
    end
    add_index :customers, :id_token, unique: true
  end
end
