# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.monetize :amount
      t.datetime :order_creation
      t.datetime :order_completion
      t.references :merchant, null: false, foreign_key: true
      t.integer :internal_id

      t.timestamps
    end
  end
end
