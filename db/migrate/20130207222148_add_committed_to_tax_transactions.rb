class AddCommittedToTaxTransactions < ActiveRecord::Migration
  def change
    add_column :avalara_tax_transactions, :committed, :boolean
  end
end
