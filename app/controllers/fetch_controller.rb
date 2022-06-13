# frozen_string_literal: true

class FetchController < ApplicationController
  def show
    if Order.first.present?
      render json: 'The orders were loaded', status: :ok
    elsif files_are_present
      FetchWorker.new.perform
      render json: 'The files are being imported', status: :ok
    else
      render json: 'Please add the files to import in the folder public/inputs', status: :ok
    end
  end

  def files_are_present
    merchants_file = Rails.root.join(Figaro.env.merchants_file_path)
    orders_file = Rails.root.join(Figaro.env.orders_file_path)
    merchants_file.present? && orders_file.present?
  end
end
