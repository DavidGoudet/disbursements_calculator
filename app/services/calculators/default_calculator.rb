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
      week_segment = (week_day - 6.days).beginning_of_day..week_day.end_of_day
      raise ArgumentError, 'The day of the week has to be a Monday' unless week_day.monday?

      merchant_cif.present? ? calculate_one_merchant(week_segment) : calculate_several_merchants(week_segment)
    end

    private

    def calculate_one_merchant(week_segment)
      merchant = Merchant.find_by(cif: merchant_cif)
      raise ArgumentError, 'The system cant find a merchant with the providen CIF' if merchant.blank?

      orders = Order.where(merchant: merchant, order_completion: week_segment)
      calculate_sum(orders).to_s
    end

    def calculate_several_merchants(week_segment)
      disbursements_by_merchant = []
      present_merchants.each do |query|
        merchant = Merchant.find(query[:merchant_id])
        orders = Order.where(merchant: merchant, order_completion: week_segment)
        disbursements_by_merchant.push(
          [merchant.name, calculate_sum(orders).to_s]
        )
      end
      disbursements_by_merchant
    end

    def calculate_sum(orders)
      orders.inject(0) { |sum, order| sum + calculate_order_disbursement(order.amount) }
    end

    def calculate_order_disbursement(amount)
      if amount < 50 && amount.positive?
        amount - (amount * Figaro.env.below_50_fee.to_d)
      elsif amount >= 50 && amount <= 300
        amount - (amount * Figaro.env.fee_50_to_300.to_d)
      elsif amount > 300
        amount - (amount * Figaro.env.over_300_fee.to_d)
      elsif amount.negative?
        raise ArgumentError, 'One of the orders amounts is negative' if amount.negative?
      end
    end

    def present_merchants
      Order.select(:merchant_id).distinct
    end
  end
end
