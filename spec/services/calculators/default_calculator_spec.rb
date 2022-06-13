# frozen_string_literal: true

RSpec.describe Calculators::DefaultCalculator, type: :service do
  describe '#call' do
    subject { described_class.new(merchant.cif, week_starting_day).call }
    let(:merchant) { create(:merchant_default) }    
    let(:week_starting_day) { '02/01/2017' }

    context 'when there are no orders in the query' do
      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when theres only one merchant and order' do
      let!(:order) { create(:order_default, merchant: merchant) }

      it 'returns the disbursement of the order' do
        disbursement = order.amount - order.amount * Figaro.env.fee_50_to_300.to_d

        expect(subject).to eq(disbursement)
      end
    end

    context 'when there are several orders for the merchant' do
      let!(:order) { create(:order_default, merchant: merchant) }
      let!(:order_2) { create(:order_default, amount: Monetize.parse('€350.994'), merchant: merchant) }
      let(:merchant_2) { create(:merchant_default) }
      let!(:order_different_merchant) { create(:order_default, amount: Monetize.parse('€100'), merchant: merchant_2) }
      let!(:order_not_in_date_range) {
        create(
          :order_default, 
          amount:             Monetize.parse('€350.994'), 
          order_completion:   '03/01/2017 14:24:01'.to_datetime, 
          merchant:           merchant
        )
      }

      it 'returns the sum of disbursements' do
        disbursement = (order.amount - order.amount * Figaro.env.fee_50_to_300.to_d) + (order_2.amount - order_2.amount * Figaro.env.over_300_fee.to_d)

        expect(subject).to eq(disbursement)
      end
    end

    context 'when theres a negative order amount' do
      let!(:negative_order) { create(:order_default, amount: Monetize.parse('€-40'), merchant: merchant) }

      it 'raises an ArgumentError' do
        expect{ subject }.to raise_error(ArgumentError)
      end
    end

    context 'when the day of the week is not a Monday' do
      it 'raises an ArgumentError' do
        subject = described_class.new(merchant.cif, '03/01/2017')

        expect{ subject.call }.to raise_error(ArgumentError)
      end
    end
  end
end