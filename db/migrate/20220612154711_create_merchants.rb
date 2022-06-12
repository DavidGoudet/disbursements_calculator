class CreateMerchants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :email
      t.string :cif
      t.integer :internal_id

      t.timestamps
    end
  end
end
