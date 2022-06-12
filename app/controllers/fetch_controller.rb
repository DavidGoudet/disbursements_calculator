# frozen_string_literal: true

class FetchController < ActionController::Base
  def show
    merchants_file = File.join(Rails.root, 'public', 'inputs', 'merchants.json')
    orders_file = File.join(Rails.root, 'public', 'inputs', 'orders.json')
    if Order.first.present?
      render json: 'The orders were loaded', status: :ok
    elsif merchants_file.present? && orders_file.present?
      FetchWorker.perform_async(merchants_file, orders_file)
      render json: 'The files are being imported', status: :ok
    else
      render json: 'Please add the files to import in the folder public/inputs', status: :ok
    end
  end
end