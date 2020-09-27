class ListingInRangeConstraint
  def matches?(request)
    format = /^\d{4}-\d{2}-\d{2}$/

    param_check_in_date = request.params[:check_in_date]
    param_check_out_date = request.params[:check_out_date]

    return false unless param_check_in_date.match?(format) && param_check_out_date.match?(format)

    check_in_date = Date.strptime(param_check_in_date, '%Y-%m-%d')
    check_out_date = Date.strptime(param_check_out_date, '%Y-%m-%d')

    check_in_date < check_out_date
  rescue
    false
  end
end
