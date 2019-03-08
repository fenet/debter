class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
    	t.string :expense
    	t.text :description
    	t.decimal :price
    	t.string :created_by, null: false
      t.timestamps
    end
  end
end
