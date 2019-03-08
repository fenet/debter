ActiveAdmin.register Expense do
permit_params :expense, :description, :price,:created_by
	
  scope :recently_added

	index do
		selectable_column
		column "Expense" do |e|
			truncate(e.expense,  :length => 15)
		end
		column "Expense Description" do |e|
			truncate(e.description,  :length => 20)
		end
		number_column :price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
		column :created_by
		column "Created At" do |c|
      c.created_at.strftime("%b %d, %Y")
    end 
		actions
	end


  form do |f|
  	f.semantic_errors
    f.inputs "new product", :multipart => true do
      f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.full_name}
	    f.input :expense 
	    f.input :description, :input_html => {:rows => 5, :cols => 20 }
	    f.input :price    
    end
    f.actions
  end

end
