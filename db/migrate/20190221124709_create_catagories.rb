class CreateCatagories < ActiveRecord::Migration[5.2]
  def change
    create_table :catagories do |t|
    	t.references :admin_user, index: true, foreign_key: true
    	t.string :catagory
      t.timestamps
    end
  end
end
