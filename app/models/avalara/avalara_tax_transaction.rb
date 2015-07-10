include Spree

module Avalara
  class AvalaraTaxTransaction < ActiveRecord::Base

    belongs_to :order, :class_name => 'Spree::Order'
    validates :order, :presence => true
    has_one :adjustment, :class_name=>'Spree::Adjustment', :as => :originator
    has_many :avalara_tax_line_items, class_name: 'Avalara::AvalaraTaxLineItem'

    def amount
      avalara_tax_line_items.sum(:amount)
    end

    def commit
      post_order_to_avalara(true)
    end

    def create_line_items
      self.avalara_tax_line_items.destroy_all

      self.order.line_items.each_with_index do |line_item, index|
        self.avalara_tax_line_items.create!({
                                              :index        => (index += 1),
                                              :sku          => line_item.variant.sku,
                                              :quantity     => line_item.quantity,
                                              :price        => line_item.price.to_f,
                                              :line_item_id => line_item.id,
                                              :tax_code     => line_item.variant.product.avalara_tax_code
                                            })
      end
    end

    def lookup
      create_line_items # TODO this could be part of the post method then we dont have to create line items when not avalara_eligible?
      post_order_to_avalara(false)
    end

    # called when order updates adjustments
    def update_adjustment(adjustment, source)
      lookup
      adjustment.update_attribute_without_callbacks(:amount, amount)
    end

    private

    def post_order_to_avalara(commit = false)
      if order.avalara_eligible?

        tax_line_items = []
        destination_code = self.order.ship_address.id
        origin_code = SpreeAvalara.ship_from_code
        self.avalara_tax_line_items.each_with_index do |line_item, i|
          next unless line_item.line_item # Skip this line item to prevent issues removing from cart.
          line_item_total = line_item.price * line_item.quantity
          line            = Avalara::Request::Line.new(:line_no => line_item.index, 
            :origin_code => origin_code, :destination_code => destination_code, 
            :sku => line_item.sku, :qty => line_item.quantity, :amount => line_item_total, :tax_code => line_item.line_item.variant.product.avalara_tax_code)
          tax_line_items << line
        end

        # Skip tax lookup if all line items have been removed from cart.
        if tax_line_items.empty?
          avalara_tax_line_items.update_all(:amount => 0)
          return true
        end

        addresses = Array.new

        address             = Avalara::Request::Address.new(:address_code => destination_code)
        address.line_1      = self.order.ship_address.address1
        address.postal_code = self.order.ship_address.zipcode
        address.region      = self.order.ship_address.state.abbr
        addresses << address
        
        address             = Avalara::Request::Address.new(:address_code => origin_code)
        address.line_1      = SpreeAvalara.ship_from_line1
        address.postal_code = SpreeAvalara.ship_from_postal_code
        address.region      = SpreeAvalara.ship_from_region
        addresses << address


        invoice = Avalara::Request::Invoice.new
        invoice.doc_code      = self.order.number
        invoice.doc_type      = "SalesInvoice"
        invoice.company_code  = SpreeAvalara.company_code #"APITrialCompany"
        invoice.customer_code = order.user.nil? ? order.email : order.user.id
        invoice.addresses     = addresses
        invoice.lines         = tax_line_items

        # A record is created when commit is true + doc_type is SalesInvoice
        if commit and !committed?
          invoice.commit   = true
        end

        begin
          response = Avalara.get_tax(invoice)

          self.update_attribute(:committed, true) if commit
          avalara_items = avalara_tax_line_items.order('avalara_tax_line_items.index ASC').to_a

          response.tax_lines.each_with_index do |tax_line, index|
            avalara_items[index].update_attribute(:amount, tax_line.tax)
          end
        rescue Avalara::ApiError => ex
          Rails.logger.error ex.message
          # If there is an API error then just fall back to using the default state sale tax amounts.
          self.avalara_tax_line_items.each do |item|
            default_amount = (item.price * item.quantity) * (SpreeAvalara.sales_tax_states[self.order.ship_address.state.abbr] || 0)
            item.update_attribute(:amount, default_amount)
          end
        end
      else
        avalara_tax_line_items.update_all(:amount => 0)
      end

      true
    end

  end
end
