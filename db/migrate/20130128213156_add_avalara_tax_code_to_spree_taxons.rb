class AddAvalaraTaxCodeToSpreeTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :avalara_tax_code, :string
  end
end
