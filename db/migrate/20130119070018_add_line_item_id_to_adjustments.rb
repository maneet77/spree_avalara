class AddLineItemIdToAdjustments < ActiveRecord::Migration
  def up
    add_column :spree_adjustments, :line_item_id, :integer
  end

  def down
    remove_column :spree_adjustments, :line_item_id
  end
end
