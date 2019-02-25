class CreateCatagories < ActiveRecord::Migration[5.2]
  def change
    create_table :catagories do |t|
    	t.string :created_by, null: false
    	t.string :name
    	t.text :desc
      t.timestamps
    end
  end
end
