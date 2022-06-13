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
      merchant = Merchant.find_by(cif: merchant_cif)
      raise ArgumentError.new("The day of the week has to be a Monday") unless week_day.monday?
      raise ArgumentError.new("The system cant find a merchant with the providen CIF") unless merchant.present?

      week_segment = (week_day-6.day).beginning_of_day..week_day.end_of_day
      orders = Order.where(merchant: merchant, :order_completion => week_segment)
      total_disbursement = orders.inject(0) { |sum, order| sum + calculate_order_disbursement(order.amount) }
    end

    private

    def calculate_order_disbursement(amount)
      raise ArgumentError.new("One of the orders amounts is negative") if amount < 0

      if amount < 50
        amount - amount * Figaro.env.below_50_fee.to_d
      elsif amount >= 50 && amount <= 300
        amount - amount * Figaro.env.fee_50_to_300.to_d
      elsif amount > 300
        amount - amount * Figaro.env.over_300_fee.to_d
      end
    end
  end
end