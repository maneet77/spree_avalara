class CreateAvalaraTaxLineItems < ActiveRecord::Migration
  def change
    create_table :avalara_tax_line_items do |t|
      t.integer :index
      t.string  :sku
      t.integer :quantity
      t.decimal :price, :precision => 8, :scale => 5, :default => 0
      t.decimal :amount, :precision => 8, :scale => 5, :default => 0
      t.references :line_item
      t.references :avalara_tax_transaction
      t.string :type

      t.timestamps
    end
    add_index :avalara_tax_line_items, :line_item_id
    add_index :avalara_tax_line_items, :avalara_tax_transaction_id
  end
end
