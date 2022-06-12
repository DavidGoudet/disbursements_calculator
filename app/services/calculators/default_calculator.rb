# frozen_string_literal: true

module Calculators
  class DefaultCalculator
    attr_reader :merchant_cif, :week_string

    def initialize(merchant_cif, week_string)
      @merchant_cif = merchant_cif
      @week_string = week_string
    end

    def call
      week_day = week_string.to_date
      raise ArgumentError.new("The day of the week has to be a Monday") unless week_day.monday?

      week_segment = week_day-6.day..week_day
      merchant = Merchant.find_by(cif: merchant_cif)
      orders = Order.where(merchant_id: merchant.id, :order_completion => week_segment)
      total_disbursement = orders.inject(0) { |sum, order| sum + calculate_order_disbursement(order.amount) }
    end

    private

    def calculate_order_disbursement(amount)
      raise ArgumentError.new("One of the orders amounts is negative") if amount < 0

      if amount < 50
        amount - amount * 0.01
      elsif amount >= 50 && amount <= 300
        amount - amount * 0.0095
      elsif amount > 300
        amount - amount * 0.0085
      end
    end
  end
end