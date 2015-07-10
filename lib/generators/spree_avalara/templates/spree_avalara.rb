# Use this initializer to configure the avalara.

SpreeAvalara.setup do |config|

  config.username = 'you@didnotsignupforyourtrialavalaraccount.com' # trial usernames are emails, others are not.'
  config.password = 'DoItNowICanWait'         
  config.endpoint = 'https://development.avalara.net'
  config.company_code = 'APITrialCompany'
  
  # Store Specific
  config.sales_tax_states = {"CA" => 0.075, "TX" => 0.0675}  #default rate if no connection.
  
  # Ship *from* address
  config.ship_from_code = 'FROM1'
  config.ship_from_line1 = '2865 Sand Hill Road'
  config.ship_from_region = 'CA'
  config.ship_from_postal_code = '94025'

end

Avalara::configuration.endpoint = SpreeAvalara.endpoint
Avalara::configuration.username = SpreeAvalara.username
Avalara::configuration.password = SpreeAvalara.password
