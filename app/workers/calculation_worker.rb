# frozen_string_literal: true

class CalculationWorker
  include Sidekiq::Worker

  def perform(merchant_cif, week_string)
    Calculators::DefaultCalculator.new(merchant_cif, week_string).call
  end
end
