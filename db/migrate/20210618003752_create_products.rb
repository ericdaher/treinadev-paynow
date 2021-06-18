class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :value
      t.decimal :discount_credit, default: 0
      t.decimal :discount_ticket, default: 0
      t.decimal :discount_pix, default: 0
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
