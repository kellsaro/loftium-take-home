require 'rails_helper'
require 'securerandom'

RSpec.describe Listing, type: :model do
  describe 'associations' do
    it { should have_many(:reservations).class_name('Reservation') }
  end

  describe 'scopes' do
    describe 'available_in_range' do
      let(:listing_id_without_reservation) { SecureRandom.uuid }
      let(:listing_id_with_reservations) { SecureRandom.uuid }

      before do
        Listing.create!(id: listing_id_without_reservation)

        Listing.create!(id: listing_id_with_reservations)
        Reservation.create!(id: SecureRandom.uuid,
          listing_id: listing_id_with_reservations,
          check_in_date: Date.strptime('2020-09-27', '%Y-%m-%d'),
          check_out_date: Date.strptime('2020-09-30', '%Y-%m-%d')
        )
        Reservation.create!(id: SecureRandom.uuid,
          listing_id: listing_id_with_reservations,
          check_in_date: Date.strptime('2020-10-03', '%Y-%m-%d'),
          check_out_date: Date.strptime('2020-10-06', '%Y-%m-%d')
        )
      end

      it 'returns listing with no reservations' do
        check_in_date = Date.strptime('2020-09-27', '%Y-%m-%d')
        check_out_date = Date.strptime('2020-09-30', '%Y-%m-%d')

        available_in_range = Listing.available_in_range(check_in_date, check_out_date)
        listing_without_reservation = Listing.find(listing_id_without_reservation)
        expect(available_in_range).to include(listing_without_reservation)
      end

      it "doesn't return listing with reservation overlaping range" do
        check_in_date = Date.strptime('2020-09-27', '%Y-%m-%d')
        check_out_date = Date.strptime('2020-09-30', '%Y-%m-%d')

        available_in_range = Listing.available_in_range(check_in_date, check_out_date)
        listing_with_reservation = Listing.find(listing_id_with_reservations)
        expect(available_in_range).not_to include(listing_with_reservation)
      end

      it "returns listing with reservations no overlaping range" do
        check_in_date = Date.strptime('2020-10-01', '%Y-%m-%d')
        check_out_date = Date.strptime('2020-10-02', '%Y-%m-%d')

        available_in_range = Listing.available_in_range(check_in_date, check_out_date)
        listing_with_reservation = Listing.find(listing_id_with_reservations)

        expect(available_in_range).to include(listing_with_reservation)
      end

      context 'when range check_out_date and reservation check_in_date are the same' do
        it "returns listing with reservation because they don't overlap" do
          check_in_date = Date.strptime('2020-10-01', '%Y-%m-%d')
          check_out_date = Date.strptime('2020-10-03', '%Y-%m-%d')

          available_in_range = Listing.available_in_range(check_in_date, check_out_date)
          listing_with_reservation = Reservation.find_by(check_in_date: check_out_date).listing

          expect(available_in_range).to include(listing_with_reservation)
        end
      end

      context 'when range check_in_date and reservation check_out_date are the same' do
        it "returns listing with reservation because they don't overlap" do
          check_in_date = Date.strptime('2020-09-30', '%Y-%m-%d')
          check_out_date = Date.strptime('2020-10-03', '%Y-%m-%d')

          available_in_range = Listing.available_in_range(check_in_date, check_out_date)
          listing_with_reservation = Reservation.find_by(check_out_date: check_in_date).listing

          expect(available_in_range).to include(listing_with_reservation)
        end
      end
    end
  end

  describe 'reserved_nights' do
    it 'returns reserved nights in ascending order' do
      listing_id = SecureRandom.uuid
      Listing.create!(id: listing_id)
      Reservation.create!(id: SecureRandom.uuid,
        listing_id: listing_id,
        check_in_date: Date.strptime('2020-09-27', '%Y-%m-%d'),
        check_out_date: Date.strptime('2020-09-30', '%Y-%m-%d')
      )
      Reservation.create!(id: SecureRandom.uuid,
        listing_id: listing_id,
        check_in_date: Date.strptime('2019-04-12', '%Y-%m-%d'),
        check_out_date: Date.strptime('2019-04-13', '%Y-%m-%d')
      )

      expected_result = ['2019-04-12', '2020-09-27', '2020-09-28', '2020-09-29']

      reserved_nights = Listing.find(listing_id).reserved_nights
      expect(reserved_nights).to eq(expected_result)
    end

    it 'returns an empty array if there are no reserved nights' do
      listing_id = SecureRandom.uuid
      Listing.create!(id: listing_id)
      expected_result = []

      reserved_nights = Listing.find(listing_id).reserved_nights
      expect(reserved_nights).to eq(expected_result)
    end
  end

end
