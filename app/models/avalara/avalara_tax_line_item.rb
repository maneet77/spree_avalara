include  Spree

module Avalara
  class AvalaraTaxLineItem < ActiveRecord::Base

    belongs_to :avalara_tax_transaction, class_name: 'Avalara::AvalaraTaxTransaction'
    belongs_to :line_item, :class_name => 'Spree::LineItem'

    attr_accessible :index, :sku, :price, :quantity, :line_item_id, :line_item_attributes, :tax_code
    accepts_nested_attributes_for :line_item

  end
end
