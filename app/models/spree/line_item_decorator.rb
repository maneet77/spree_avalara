Spree::LineItem.class_eval do

  has_many :adjustments, :class_name => "Spree::Adjustment"

  has_one :avalara_tax_line_item, class_name: 'Avalara::AvalaraTaxLineItem'

end
