# frozen_string_literal: true

class CalculatorController < ApplicationController
  def show
    begin
      amount = Calculators::DefaultCalculator.new(params[:merchant_cif], params[:week]).call
      render json: amount.to_s, status: :ok
    rescue ArgumentError => e
      render json: e, status: :bad_request
    end
  end
end
