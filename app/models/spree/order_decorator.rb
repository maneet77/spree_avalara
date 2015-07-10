require_relative '../avalara/avalara_tax_transaction'
require_relative '../avalara/avalara_tax_line_item'

Spree::Order.class_eval do

  class AuthorizeNetNotConfigured < RuntimeError; end

  has_one :avalara_tax_transaction, :class_name => 'Avalara::AvalaraTaxTransaction'

  after_save :ship_address_tax_update

  before_create :create_avalara_tax_transaction

  ## Class Methods

  ## Instance Methods

  # Only call avalara if state is one we charge sales tax for.
  def avalara_eligible?
    if ship_address.present? and ship_address.state.present?
      SpreeAvalara.sales_tax_states.keys.include? ship_address.state.abbr
    else
      false
    end
  end

  def create_tax_charge!
    return true if avalara_tax_transaction.committed?
    adjustments.where(originator_type: 'Avalara::AvalaraTaxTransaction').destroy_all
    # Create tax estimate and required adjustment.
    create_avalara_tax_adjustment
  end


  # Commits tax transaction to avalara when order is finalized.
  def finalize_with_avalara_tax!
    finalize_without_avalara_tax!

    avalara_tax_transaction.commit
  end
  alias_method_chain :finalize!, :avalara_tax


  private

  def create_avalara_tax_adjustment
    create_avalara_tax_transaction if avalara_tax_transaction.nil?

    if self.ship_address.present? and self.line_items.size > 0
      avalara_tax_transaction.lookup

      if adjustment = Spree::Adjustment.find_by_originator_id_and_originator_type(avalara_tax_transaction.id, 'Avalara::AvalaraTaxTransaction')
        adjustment.update_attribute(:amount, avalara_tax_transaction.amount)
      else
        adjustments.create!({:amount => self.avalara_tax_transaction.amount,
                             :source => self,
                             :originator => self.avalara_tax_transaction,
                             :locked => true,
                             :label => "Sales Tax"}, :without_protection => true)
      end
    end
  end

  def create_avalara_tax_transaction
    unless self.avalara_tax_transaction.present?
      self.avalara_tax_transaction = Avalara::AvalaraTaxTransaction.new
    end
  end

  # If the shipping address changes we want to update tax.
  def ship_address_tax_update
    if ship_address and (ship_address_id_changed? or ship_address.changed?)
      create_avalara_tax_adjustment
    end
  end

end
