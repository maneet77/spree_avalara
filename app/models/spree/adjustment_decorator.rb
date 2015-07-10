Spree::Adjustment.class_eval do
  belongs_to :line_item, :class_name => "Spree::LineItem"

  attr_accessible :line_item_id

  def serializable_hash(options={})
    if originator_type == "Avalara::AvalaraTaxTransaction"
      super.merge(:originator_type => "Spree::TaxRate")
    else
      super
    end
  end

end
