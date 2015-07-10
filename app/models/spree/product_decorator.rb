Spree::Product.class_eval do

  def avalara_tax_code
    taxons.select(:avalara_tax_code).where('avalara_tax_code is not null').pluck('avalara_tax_code').first
  end

end
