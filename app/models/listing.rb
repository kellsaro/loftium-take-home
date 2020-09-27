class Listing < ApplicationRecord
  self.primary_key = 'id'
  has_many :reservations, -> { order "check_in_date ASC" }, inverse_of: :listing

  scope :available_in_range, -> (check_in_date, check_out_date) {
    where('id NOT IN '\
          '(SELECT reservations.listing_id'\
          ' FROM reservations'\
          ' WHERE (:check_in_date <= check_in_date AND check_in_date < :check_out_date)'\
          '    OR (:check_in_date < check_out_date AND check_out_date <= :check_out_date))',
      { check_in_date: check_in_date, check_out_date: check_out_date }).distinct
  }

  def reserved_nights
    reservations.map {|r| r.reserved_nights }.flatten
  end
end

# Table "public.listings"
# Column  | Type | Collation | Nullable | Default
# --------+------+-----------+----------+---------
# id      | uuid |           |          |
