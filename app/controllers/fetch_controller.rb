# frozen_string_literal: true

class FetchController < ApplicationController
  def show
    if files_are_present
      FetchWorker.new.perform if Order.first.blank?
      render json: 'The orders were loaded', status: :ok
    else
      render json: 'Please add the files to import in the folder public/inputs', status: :ok
    end
  end

  private

  def files_are_present
    merchants_file = Rails.root.join(Figaro.env.merchants_file_path)
    orders_file = Rails.root.join(Figaro.env.orders_file_path)
    File.exist?(merchants_file) && File.exist?(orders_file)
  end
end
