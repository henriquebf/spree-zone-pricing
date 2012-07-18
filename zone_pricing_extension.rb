class ZonePricingExtension < Spree::Extension

  version "0.1.7"
  description "Spree Zone Pricing"
  url "https://github.com/henriquebf/spree-zone-pricing"

  # Please use zone_pricing/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate

    # Add helper to retrieve the users country
    ApplicationHelper.send(:include, Spree::ZonePricing::GetCountry)
    # Add helper to retrieve the users country, used by a number of controllers
    Spree::BaseController.send(:include, Spree::ZonePricing::GetCountry)

    # Add additional associations to allow m:m relationship
    # between zones<->variants
    Zone.send(:include, Spree::ZonePricing::Zone)
    Variant.send(:include, Spree::ZonePricing::Variant)

    # Override add_variant method so that we can use zone pricing
    Order.send(:include, Spree::ZonePricing::Order)

    # Override price
    ProductsHelper.send(:include, Spree::ZonePricing::ProductsHelper)

    # Add action to countries controller to handle country selection
    CountriesController.send(:include, Spree::ZonePricing::CountriesController)
    # Add code to set the currently country in the order
    OrdersController.send(:include, Spree::ZonePricing::OrdersController)
    # Add code to save zone prices
    Admin::VariantsController.send(:include, Spree::ZonePricing::Admin::VariantsController)
    # Add code to check zone prices after address is saved during checkout, if ship
    # country not the same change prices in order
    CheckoutsController.send(:include, Spree::ZonePricing::CheckoutsController)

  end

end