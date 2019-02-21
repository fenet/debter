class CreateProductCatagories < ActiveRecord::Migration[5.2]
  def change
    create_table :product_catagories do |t|
    	t.references :product, index: true, foreign_key: true
      t.references :catagory, index: true, foreign_key: true
      t.timestamps
    end
  end
end
