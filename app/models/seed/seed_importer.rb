# encoding: UTF-8

module  SeedImporter
  
  def avalara_taxons

    input_file_exists = false # feel free to create it.
    if input_file_exists 
      puts "Importing taxon tax codes for Avalara"
      #TODO Read a generic CSV for demo data.
    else
      puts "WARNING: invalid or missing tax categorization."
      puts "  or do you really only sell men's wallets?"
      mens_wallets = "PC040209" # arbitrary avalara tax code/tax category
      Spree::Taxonomy.all.each do |ty|
        ty.taxons.each do |taxon|  # think DRY - 1 taxon w/ tax code/product.
          taxon.avalara_tax_code = mens_wallets
          taxon.save!
        end
      end
    end
  end
end