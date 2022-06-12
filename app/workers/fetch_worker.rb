# frozen_string_literal: true

class FetchWorker
  include Sidekiq::Worker

  def perform(merchants_path, orders_path)
    Fetchers::JsonFetcher.new(merchants_path, orders_path).call
  end
end