class CreateProductItems < ActiveRecord::Migration[5.2]
  def change
    create_table :product_items do |t|
    	t.references :product, index: true, foreign_key: true
    	t.references :sale, index: true, foreign_key: true
    	t.decimal :saling_price
    	t.integer :quanity, null: false
      t.timestamps
    end
  end
end
