# frozen_string_literal: true

class CalculatorController < ActionController::Base
  def show
    amount = Calculators::DefaultCalculator.new(params[:merchant_cif], params[:week]).call
    render json: amount.to_s, status: :ok
  end
end