class CreateAvalaraTaxTransactions < ActiveRecord::Migration
  def change
    create_table :avalara_tax_transactions do |t|
      t.references :order
      t.string :message
      t.timestamps
    end
    add_index :avalara_tax_transactions, :order_id
  end
end
