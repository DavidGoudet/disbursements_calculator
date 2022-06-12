# frozen_string_literal: true

module Fetchers
  class JsonFetcher
    attr_reader :merchants_path, :orders_path

    def initialize(merchants_path, orders_path)
      @merchants_path = merchants_path
      @orders_path = orders_path
    end

    def call
      merchants_data = File.read(merchants_path)
      orders_data = File.read(orders_path)
      save_merchants(JSON.parse(merchants_data)['RECORDS'])
      save_orders(JSON.parse(orders_data)['RECORDS'])
    end

    private

    def save_merchants(merchants_data)
      raise ArgumentError.new('The JSON data for merchants is not correctly formatted') if merchants_data.nil?

      merchants_data.each do |merchant|
        Merchant.create(
          internal_id: merchant['id'],
          name: merchant['name'],
          email: merchant['email'],
          cif: merchant['cif']
        )
      end
    end

    def save_orders(orders_data)
      raise ArgumentError.new('The JSON data for orders is not correctly formatted') if orders_data.nil?

      orders_data.each do |order|
        new_order = Order.create(
          internal_id: order['id'],
          amount: Monetize.parse("€#{order['amount']}"),
          merchant: Merchant.find_by(internal_id: order['merchant_id']),
          order_creation: order['created_at'].to_datetime
        )
        new_order.update(order_completion: order['completed_at'].to_datetime) if order['completed_at'].present?
      end
    end
  end
end