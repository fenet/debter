class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
    	t.string :customer_name
    	t.string :phone_number
    	t.string :address
    	t.boolean :include_tax
    	t.string :type_of_sales
    	t.decimal :total_price
      t.decimal :down_payment
      t.boolean :fully_payed
    	t.string :created_by, null: false
      t.timestamps
    end
  end
end
