require 'rails_helper'

describe ListingInRangeConstraint do
  describe '#matches?(request)' do
    let(:request) { ActionDispatch::Request.new(nil) }
    let(:params) {
      {
        check_in_date: check_in_date,
        check_out_date: check_out_date
      }
    }

    before do
      allow(request).to receive(:params).and_return(params)
    end

    context "when :check_in_date and :check_out_date doesn't match format" do
      let(:check_in_date) { '20200923' }
      let(:check_out_date) { '20201214' }

      it 'returns false' do
        expect(subject.matches?(request)).to be false
      end
    end

    context "when :check_in_date == :check_out_date" do
      let(:check_in_date) { '2020-09-23' }
      let(:check_out_date) { '2020-09-23' }

      it 'returns false' do
        expect(subject.matches?(request)).to be false
      end
    end

    context "when :check_in_date > :check_out_date" do
      let(:check_in_date) { '2020-09-24' }
      let(:check_out_date) { '2020-09-23' }

      it 'returns false' do
        expect(subject.matches?(request)).to be false
      end
    end

    context "when :check_in_date or :check_out_date is an invalid date" do
      let(:check_in_date) { '2020-02-30' }
      let(:check_out_date) { '2020-09-23' }

      it 'returns false' do
        expect(subject.matches?(request)).to be false
      end
    end

    context "when :check_in_date < :check_out_date" do
      let(:check_in_date) { '2020-09-22' }
      let(:check_out_date) { '2020-09-23' }

      it 'returns true' do
        expect(subject.matches?(request)).to be true
      end
    end
  end
end