SpreeAvalara
============

Calulate taxes better! Use Avalara.  Avalara is a tax service which allows eCommerce merchants to accurately calculate
sales tax.  This allow the merchant to avoid manually updating tax tables and also helps preclude the likelihood of an
unfavorable tax audit.

The extension uses the avalara gem to communicate with Avalara's AvaTax REST API v1.0. Configuration is simple and is detailed below.

Before you start you will need
------------------------------

An Avalara AvaTax account. Trial accounts are free and start their lives with a fully functioning company that charges sales tax everywhere. Free trial signup at the Avalara developer site: [developer.avalara.com](http://developer.avalara.com/api-get-started)

Before you go too far you will need
-----------------------------------

Know how to categorize your products by tax code since different products are taxed differently. By default the gem assumes you are selling mens wallets, and perhaps you are.

You may want to create specific taxons to simplify grouping products into taxable groups. Ultimately tax codes are associated with products through taxons.


Getting Started
================

* Get a trial Avalara account (avalara.com). Credentials are an email and a generated password.
* Add gem to Gemfile: :

    `gem 'avalara', :github => 'ehwinter/avalara', :branch => '1-3-stable'`
    
    `gem 'spree_avalara', :github => 'ehwinter/spree_avalara', :branch => '1-3-stable' ` 

* install :

    `bundle install`
    
    `bundle exec rails g spree_avalara:install`

* edit and update config/initializers/spree_avalara.rb
* update tax codes associated with your products. :

    `bundle exec rake avalara:import:avalara_codes # import tax codes for avalara or sell wallets`


Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against. :

    bundle
    bundle exec rake test_app
    bundle exec rspec spec

Copyright (c) 2013 RailsDog, LLC, released under the New BSD License
