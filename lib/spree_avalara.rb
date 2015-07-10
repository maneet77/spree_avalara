require 'spree_core'
require 'spree_avalara/engine'

module SpreeAvalara
  # Communicate to Avalara API
  mattr_accessor :username
  mattr_accessor :password
  mattr_accessor :endpoint
  mattr_accessor :company_code

  # Store specific
  mattr_accessor :sales_tax_states
  
  # Ship *from* address
  mattr_accessor :ship_from_code
  mattr_accessor :ship_from_line1
  mattr_accessor :ship_from_region
  mattr_accessor :ship_from_postal_code
  
  # Default way to setup SpreeAvalara. Run rake avalara:install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

end
