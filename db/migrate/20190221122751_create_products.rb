class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
    	t.references :admin_user, index: true, foreign_key: true
    	t.string :product_name, index: true, null: false
    	t.string :photo
    	t.decimal :unit_price, null: false
    	t.text :description
    	t.string :serial_number
    	t.integer :quanity, null: false
    	t.decimal :selling_price
    	t.string :type_of_sales
      t.timestamps
    end
  end
end
