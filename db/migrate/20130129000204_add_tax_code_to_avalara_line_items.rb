class AddTaxCodeToAvalaraLineItems < ActiveRecord::Migration
  def change
    add_column :avalara_tax_line_items, :tax_code, :string
  end
end
