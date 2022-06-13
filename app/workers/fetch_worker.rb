# frozen_string_literal: true

class FetchWorker
  include Sidekiq::Worker

  def perform
    Fetchers::JsonFetcher.new.call
  end
end
