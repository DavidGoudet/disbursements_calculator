# frozen_string_literal: true

FactoryBot.define do
  factory :merchant_default, class: 'Merchant' do
    name  { 'My Merchant' }
    email { 'test@merchantemail.com' }
    cif   { 'B611111111' }
  end
end
