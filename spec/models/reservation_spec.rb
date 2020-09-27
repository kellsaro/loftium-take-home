require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'associations' do
    it { should belong_to(:listing).class_name('Listing') }
    it { should validate_presence_of(:listing_id) }
    it { should validate_presence_of(:check_in_date) }
    it { should validate_presence_of(:check_out_date) }
  end

  describe '#reserved_nights' do
    it "doesn't include check out date night" do
      check_in_date = Date.strptime('2020-09-27', '%Y-%m-%d')
      check_out_date = Date.strptime('2020-09-29', '%Y-%m-%d')
      reservation = Reservation.new(check_in_date: check_in_date, check_out_date: check_out_date)
      reserved_nights = reservation.reserved_nights

      expected_result = ['2020-09-27', '2020-09-28']
      expect(reserved_nights).to eq(expected_result)
    end
  end
end
