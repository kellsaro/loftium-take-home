class Reservation < ApplicationRecord
  self.primary_key = 'id'
  belongs_to :listing, inverse_of: :reservations

  validates :listing_id, :check_in_date, :check_out_date, presence: true

  def reserved_nights
    (check_in_date...check_out_date).map { |d| d.strftime('%Y-%m-%d') }
  end
end

# Table "public.reservations"
# Column          | Type | Collation | Nullable | Default
# ----------------+------+-----------+----------+---------
# id              | uuid |           |          |
# listing_id      | uuid |           |          |
# check_in_date   | date |           |          |
# check_out_date  | date |           |          |
