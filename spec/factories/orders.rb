# frozen_string_literal: true

FactoryBot.define do
  factory :order_default, class: 'Order' do
    amount { Monetize.parse('€61.74') }
    order_creation { '01/01/2017 00:00:00'.to_datetime }
    order_completion { '01/01/2017 14:24:01'.to_datetime }
  end
end
