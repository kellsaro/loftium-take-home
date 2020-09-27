class Api::V1::ListingsController < ApplicationController
  def index
    check_in_date = Date.strptime(params[:check_in_date], '%Y-%m-%d')
    check_out_date = Date.strptime(params[:check_out_date], '%Y-%m-%d')

    result = Listing.available_in_range(check_in_date, check_out_date)
    render json: result
  end

  def unavailable_nights
    result = Listing.find(params[:id]).reserved_nights
    render json: result
  rescue
    head :not_found
  end
end
