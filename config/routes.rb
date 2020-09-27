Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json }, constraints: lambda { |req| req.format == :json } do
    namespace :v1 do
      get 'listings/from/:check_in_date/to/:check_out_date', to: 'listings#index', constraints: ListingInRangeConstraint.new
      get 'listings/:id/unavailable_nights', to: 'listings#unavailable_nights'
    end
  end

  mount Apidoco::Engine, at: "/docs"
end
