require 'rails_helper'

RSpec.describe 'Api::V1::Listings', type: :request do

  describe 'GET /api/v1/listings/from/:check_in_date/to/:check_out_date' do
    context 'when there are not listings' do
      it 'returns empty response' do
        get '/api/v1/listings/from/2020-09-30/to/2020-10-03'
        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    context 'when there are listings and reservations' do
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

      it 'returns http success' do
        get '/api/v1/listings/from/2020-09-30/to/2020-10-03'
        expect(response).to have_http_status(:success)
      end

      it 'returns listing without reservations' do
        get '/api/v1/listings/from/2020-09-30/to/2020-10-03'

        body = JSON.parse(response.body)
        expect(body).to include({ 'id' => listing_id_without_reservation })
      end

      it 'returns listing with reservations no overlaping range' do
        get '/api/v1/listings/from/2020-09-30/to/2020-10-03'

        body = JSON.parse(response.body)
        expect(body).to include({ 'id' => listing_id_with_reservations })
      end
    end
  end

  describe 'GET /api/v1/listings/:id/unavailable_nights' do
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
        check_in_date: Date.strptime('2020-04-12', '%Y-%m-%d'),
        check_out_date: Date.strptime('2020-04-13', '%Y-%m-%d')
      )
    end

    context 'when there is no listing with the id' do
      it 'returns http error' do
        get '/api/v1/listings/wrong-id/unavailable_nights'
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the listing does not have reservations' do
      it 'returns http success' do
        get "/api/v1/listings/#{listing_id_without_reservation}/unavailable_nights"
        expect(response).to have_http_status(:success)
      end

      it 'returns an empty response' do
        get "/api/v1/listings/#{listing_id_without_reservation}/unavailable_nights"
        body = JSON.parse(response.body)

        expect(body).to be_empty
      end
    end

    context 'when the listing does have reservations' do
      it 'returns http success' do
        get "/api/v1/listings/#{listing_id_with_reservations}/unavailable_nights"
        expect(response).to have_http_status(:success)
      end

      it 'returns with nights in ascending order' do
        get "/api/v1/listings/#{listing_id_with_reservations}/unavailable_nights"
        body = JSON.parse(response.body)

        expect(body).to eq(['2020-04-12', '2020-09-27', '2020-09-28', '2020-09-29'])
      end
    end
  end
end
