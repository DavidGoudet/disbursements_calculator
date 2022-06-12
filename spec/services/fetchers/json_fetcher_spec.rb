# frozen_string_literal: true

RSpec.describe Fetchers::JsonFetcher, type: :service do
  describe '#call' do
    context 'when theres a valid json with orders' do
      it 'returns the saved orders' do
        merchants_fixture = File.join(Rails.root, 'spec', 'fixtures', 'fetchers', 'merchants.json')
        orders_fixture = File.join(Rails.root, 'spec', 'fixtures', 'fetchers', 'orders.json')
        described_class.new(merchants_fixture, orders_fixture).call

        expect(Merchant.all.size).to eq(14)
        expect(Order.all.size).to eq(3240)
        expect(Order.find_by(internal_id: 3).amount.to_s).to eq('445.5')
        expect(Order.find_by(internal_id: 63).merchant.name).to eq('Oga Inc')
      end
    end
  end
end