class AddMonetizeToOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :amount_cents
    remove_column :orders, :amount_currency

    change_table :orders do |t|
      t.monetize :amount
      t.decimal :amount
    end
  end
end
