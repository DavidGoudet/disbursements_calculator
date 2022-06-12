MoneyRails.configure do |config|
  config.default_currency = :eur
end

Money.locale_backend = :currency
Money.default_infinite_precision = true